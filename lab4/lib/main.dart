import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      home: const MyHomePage(title: 'Общежития КубГАУ'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLiked = false;
  int _likesCount = 26;

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _likesCount--;
      } else {
        _likesCount++;
      }
      _isLiked = !_isLiked;
    });
  }

  Future<void> _call() async {
    final Uri launchUri = Uri(scheme: 'tel', path: '+79892830260');
    await launchUrl(launchUri);
  }

  Future<void> _openRoute() async {
    final Uri mapUri = Uri.parse(
      'geo:0,0?q=45.0502933,38.9207626(Общежитие 20)',
    );

    await launchUrl(mapUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/20.webp'),
            Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Общежитие №20',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              'Краснодар, ул. Калинина 13',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: _toggleLike,
                        borderRadius: BorderRadius.circular(20),
                        child: Row(
                          children: [
                            Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 28,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$_likesCount',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          _call();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Icon(Icons.phone, color: Colors.green, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'ПОЗВОНИТЬ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _openRoute();
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Icon(Icons.near_me, color: Colors.green, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'МАРШРУТ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          SharePlus.instance.share(
                            ShareParams(
                              text:
                                  'Общежитие №20 КубГАУ\nАдрес: Краснодар, ул. Калинина, 13к20',
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Column(
                          children: [
                            Icon(Icons.share, color: Colors.green, size: 32),
                            SizedBox(height: 4),
                            Text(
                              'ПОДЕЛИТЬСЯ',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28),
                  Text(
                    'Студенческий городок или так называемый кампус Кубанского ГАУ состоит '
                    'из двадцати общежитий, в которых проживает более 8000 студентов, что составляет '
                    '96% от всех нуждающихся. Студенты первого курса обеспечены местами в общежитии '
                    'полностью. В соответствии с Положением о студенческих общежитиях '
                    'университета, при поселении между администрацией и студентами заключается '
                    'договор найма жилого помещения. Воспитательная работа в общежитиях направлена '
                    'на улучшение быта, соблюдение правил внутреннего распорядка, отсутствия '
                    'асоциальных явлений в молодежной среде. Условия проживания в общежитиях '
                    'университетского кампуса полностью отвечают санитарным нормам и требованиям: '
                    'наличие оборудованных кухонь, душевых комнат, прачечных, читальных залов, '
                    'комнат самоподготовки, помещений для заседаний студенческих советов и '
                    'наглядной агитации. С целью улучшения условий быта студентов активно работает '
                    'система студенческого самоуправления - студенческие советы организуют всю работу '
                    'по самообслуживанию.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
