import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class VIPService {
  final String username = 'Semar12'; // ganti dengan username akun VIPReseller kamu
  final String apiKey = 'nPd0MVcl6Joxpo0r6Z99x581uzoRVOi3hZes8yv23seHCvhjL5ovzsUcAkfcpAxp';     // ganti dengan API Key kamu
  final String baseUrl = 'https://vip-reseller.co.id/api';

  Future<List<dynamic>> fetchPriceList() async {
    final response = await http.post(
      Uri.parse(baseUrl),
      body: {
        'username': username,
        'apiKey': apiKey,
        'sign': md5.convert(utf8.encode(username + apiKey + 'pricelist')).toString(),
        'type': 'pricelist',
      },
    );

    final result = jsonDecode(response.body);
    if (result['result'] == true) {
      return List.from(result['data']);
    } else {
      throw Exception(result['message']);
    }
  }

  Future<Map<String, dynamic>> orderPulsa(String nomorHp, String kodeProduk) async {
  try {
    final sign = md5.convert(utf8.encode(username + apiKey + kodeProduk)).toString();
    
    final response = await http.post(
      Uri.parse('$baseUrl/order'), // Pastikan endpoint spesifik
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {
        'username': username,
        'apiKey': apiKey,
        'sign': sign,
        'type': 'order',
        'kode_produk': kodeProduk,
        'tujuan': nomorHp,
        'ref_id': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('HTTP ${response.statusCode}: ${response.body}');
    }
  } catch (e) {
    throw Exception('Order failed: $e');
  }
}
}
