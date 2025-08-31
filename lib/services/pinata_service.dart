import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import '../models/contract_config.dart';
import '../models/product.dart';

/// Servicio para interactuar con Pinata Cloud para almacenamiento IPFS
class PinataService {
  static final Dio _dio = Dio();
  static const String _baseUrl = 'https://api.pinata.cloud';
  
  static void _configureDio() {
    _dio.options.headers = {
      'Authorization': 'Bearer ${ContractConfig.pinataConfig['JWT']}',
      'Content-Type': 'application/json',
    };
  }
  
  /// Sube una imagen a IPFS y retorna el hash
  static Future<String> uploadImage(File imageFile) async {
    try {
      _configureDio();
      
      // Determinar el tipo MIME del archivo
      final mimeType = lookupMimeType(imageFile.path) ?? 'application/octet-stream';
      
      // Crear FormData para el archivo
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: path.basename(imageFile.path),
          contentType: DioMediaType.parse(mimeType),
        ),
        'pinataMetadata': jsonEncode({
          'name': 'Koneque Product Image - ${path.basename(imageFile.path)}',
          'keyvalues': {
            'app': 'koneque',
            'type': 'product_image',
            'timestamp': DateTime.now().toIso8601String(),
          }
        }),
        'pinataOptions': jsonEncode({
          'cidVersion': 1,
          'customPinPolicy': {
            'regions': [
              {'id': 'FRA1', 'desiredReplicationCount': 1},
              {'id': 'NYC1', 'desiredReplicationCount': 1}
            ]
          }
        }),
      });
      
      final response = await _dio.post(
        '$_baseUrl/pinning/pinFileToIPFS',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${ContractConfig.pinataConfig['JWT']}',
          },
        ),
      );
      
      if (response.statusCode == 200) {
        final ipfsHash = response.data['IpfsHash'] as String;
        print('✅ Imagen subida a IPFS: $ipfsHash');
        return ipfsHash;
      } else {
        throw Exception('Error subiendo imagen: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error subiendo imagen a Pinata: $e');
      rethrow;
    }
  }
  
  /// Sube múltiples imágenes y retorna una lista de hashes
  static Future<List<String>> uploadImages(List<File> imageFiles) async {
    final List<String> ipfsHashes = [];
    
    for (final imageFile in imageFiles) {
      try {
        final hash = await uploadImage(imageFile);
        ipfsHashes.add(hash);
      } catch (e) {
        print('❌ Error subiendo imagen ${imageFile.path}: $e');
        // Continuar con las demás imágenes
      }
    }
    
    return ipfsHashes;
  }
  
  /// Sube metadatos del producto a IPFS
  static Future<String> uploadProductMetadata(ProductMetadata metadata) async {
    try {
      _configureDio();
      
      final metadataJson = {
        ...metadata.toJson(),
        'version': '1.0',
        'standard': 'Koneque Product Metadata',
        'uploadedAt': DateTime.now().toIso8601String(),
      };
      
      final pinataMetadata = {
        'name': 'Koneque Product Metadata - ${metadata.name}',
        'keyvalues': {
          'app': 'koneque',
          'type': 'product_metadata',
          'product_name': metadata.name,
          'timestamp': DateTime.now().toIso8601String(),
        }
      };
      
      final pinataOptions = {
        'cidVersion': 1,
        'customPinPolicy': {
          'regions': [
            {'id': 'FRA1', 'desiredReplicationCount': 1},
            {'id': 'NYC1', 'desiredReplicationCount': 1}
          ]
        }
      };
      
      final requestData = {
        'pinataContent': metadataJson,
        'pinataMetadata': pinataMetadata,
        'pinataOptions': pinataOptions,
      };
      
      final response = await _dio.post(
        '$_baseUrl/pinning/pinJSONToIPFS',
        data: requestData,
      );
      
      if (response.statusCode == 200) {
        final ipfsHash = response.data['IpfsHash'] as String;
        print('✅ Metadatos subidos a IPFS: $ipfsHash');
        return ipfsHash;
      } else {
        throw Exception('Error subiendo metadatos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error subiendo metadatos a Pinata: $e');
      rethrow;
    }
  }
  
  /// Obtiene metadatos desde IPFS usando el hash
  static Future<ProductMetadata> getProductMetadata(String ipfsHash) async {
    try {
      final gatewayUrl = '${ContractConfig.pinataConfig['GATEWAY_URL']}/ipfs/$ipfsHash';
      
      final response = await _dio.get(gatewayUrl);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return ProductMetadata.fromJson(data);
      } else {
        throw Exception('Error obteniendo metadatos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error obteniendo metadatos desde IPFS: $e');
      rethrow;
    }
  }
  
  /// Obtiene una imagen desde IPFS
  static String getImageUrl(String ipfsHash) {
    return '${ContractConfig.pinataConfig['GATEWAY_URL']}/ipfs/$ipfsHash';
  }
  
  /// Lista todos los archivos pinneados por la cuenta
  static Future<List<Map<String, dynamic>>> listPinnedFiles() async {
    try {
      _configureDio();
      
      final response = await _dio.get(
        '$_baseUrl/data/pinList',
        queryParameters: {
          'status': 'pinned',
          'pageLimit': 100,
          'metadata[keyvalues]["app"]': 'koneque',
        },
      );
      
      if (response.statusCode == 200) {
        final rows = response.data['rows'] as List;
        return rows.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Error listando archivos: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error listando archivos de Pinata: $e');
      return [];
    }
  }
  
  /// Elimina un archivo de IPFS (unpin)
  static Future<bool> unpinFile(String ipfsHash) async {
    try {
      _configureDio();
      
      final response = await _dio.delete(
        '$_baseUrl/pinning/unpin/$ipfsHash',
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Error eliminando archivo de Pinata: $e');
      return false;
    }
  }
  
  /// Obtiene información de uso de la cuenta
  static Future<Map<String, dynamic>?> getAccountInfo() async {
    try {
      _configureDio();
      
      final response = await _dio.get('$_baseUrl/data/userPinnedDataTotal');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Error obteniendo información de cuenta: $e');
      return null;
    }
  }
  
  /// Valida la conectividad con Pinata
  static Future<bool> testConnection() async {
    try {
      _configureDio();
      
      final response = await _dio.get('$_baseUrl/data/testAuthentication');
      
      if (response.statusCode == 200) {
        print('✅ Conexión con Pinata exitosa');
        return true;
      }
      return false;
    } catch (e) {
      print('❌ Error de conexión con Pinata: $e');
      return false;
    }
  }
}
