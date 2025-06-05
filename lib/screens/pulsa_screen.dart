import 'package:flutter/material.dart';
import 'package:semar/screens/vip_screen.dart';

class PulsaScreen extends StatefulWidget {
  @override
  _PulsaScreenState createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  final VIPService _vipService = VIPService();
  late Future<List<dynamic>> _pricelist;
  final TextEditingController _hpController = TextEditingController(text: '081568206075');
  String? _selectedProduct;
  String? _selectedOperator;

  List<String> operatorList = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPriceList();
  }

  Future<void> _loadPriceList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Try to fetch from API first
      final apiData = await _vipService.fetchPriceList();
      final operators = apiData.map((item) => item['brand'].toString()).toSet().toList();
      
      setState(() {
        operatorList = operators;
        _pricelist = Future.value(apiData);
      });
    } catch (e) {
      // If API fails, use mock data
      final mockData = _getMockPriceList();
      final operators = mockData.map((item) => item['brand'].toString()).toSet().toList();
      
      setState(() {
        operatorList = operators;
        _pricelist = Future.value(mockData);
        _errorMessage = 'Gagal memuat data dari server. Menampilkan data contoh.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getMockPriceList() {
    return [
      {
        "brand": "Telkomsel",
        "product_name": "Pulsa 5.000",
        "code": "TSEL5",
        "price": 6000
      },
      {
        "brand": "Telkomsel",
        "product_name": "Pulsa 10.000",
        "code": "TSEL10",
        "price": 11000
      },
      {
        "brand": "Telkomsel",
        "product_name": "Pulsa 25.000",
        "code": "TSEL25",
        "price": 26000
      },
      {
        "brand": "Indosat",
        "product_name": "Pulsa 5.000",
        "code": "IND5",
        "price": 6000
      },
      {
        "brand": "Indosat",
        "product_name": "Pulsa 10.000",
        "code": "IND10",
        "price": 11000
      },
      {
        "brand": "XL",
        "product_name": "Pulsa 5.000",
        "code": "XL5",
        "price": 6000
      },
      {
        "brand": "XL",
        "product_name": "Pulsa 10.000",
        "code": "XL10",
        "price": 11000
      },
      {
        "brand": "Axis",
        "product_name": "Pulsa 5.000",
        "code": "AXIS5",
        "price": 6000
      },
      {
        "brand": "Smartfren",
        "product_name": "Pulsa 5.000",
        "code": "SMART5",
        "price": 6000
      },
    ];
  }

  void _beliPulsa() async {
    if (_selectedProduct == null || _hpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan nomor HP dan pilih produk')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _vipService.orderPulsa(_hpController.text, _selectedProduct!);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(result['result'] ? 'Sukses' : 'Gagal'),
          content: Text(result['message']),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Gagal melakukan pemesanan: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulsa & Paket Data'),
        backgroundColor: Color(0xFF275E76),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _hpController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Nomor HP',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: _selectedOperator,
                  hint: Text("Pilih Operator"),
                  isExpanded: true,
                  items: operatorList.map((operator) {
                    return DropdownMenuItem<String>(
                      value: operator,
                      child: Text(operator),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedOperator = value;
                      _selectedProduct = null;
                    });
                  },
                ),
                SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: _pricelist,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data ?? [];
                      final filtered = _selectedOperator == null
                          ? []
                          : data.where((item) => item['brand'] == _selectedOperator).toList();

                      return filtered.isEmpty
                          ? Center(child: Text('Pilih operator untuk melihat produk'))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                final isSelected = _selectedProduct == item['code'];

                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    title: Text('${item['product_name']}'),
                                    subtitle: Text('Harga: Rp${item['price']}'),
                                    trailing: isSelected
                                        ? Icon(Icons.check_circle, color: Colors.green)
                                        : null,
                                    tileColor: isSelected
                                        ? Colors.green.withOpacity(0.1)
                                        : null,
                                    onTap: () {
                                      setState(() {
                                        _selectedProduct = item['code'];
                                      });
                                    },
                                  ),
                                );
                              },
                            );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _beliPulsa,
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Beli Sekarang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF275E76),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}