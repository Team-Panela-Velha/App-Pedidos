import 'package:app_pedidos/ui/widgets/simple_button.dart';
import 'package:flutter/material.dart';

class SelectTable extends StatefulWidget {
  const SelectTable({super.key});

  @override
  State<SelectTable> createState() => _SelectTableState();
}

class _SelectTableState extends State<SelectTable> {
  final TextEditingController tableCodeController = TextEditingController();
  
  void login() {
  String pass = tableCodeController.text;

  if (pass == "1234") {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Table Not Foud"),
        backgroundColor: Colors.red,
      ),
    );
  }
}

@override
  Widget build(BuildContext context){
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FlutterLogo(size: 100),
            const SizedBox(height: 32),

            Center(
              child: SizedBox(
                width: 250,
                child: Text(
                  "Please enter the code to access your desired table.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            Center(
              child: SizedBox(
                height: 52,
                width: 240,
                child: TextField(
                  controller: tableCodeController,
                  textAlign: TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Table Code",
                    hintStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFBFAFA6),
                    ),
                  filled: true,
                  fillColor: Color(0xFFE8DED7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          SimpleButton(onTap: login, text: "Select Table")
        ],
      )
    ),
  );
}
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Page"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: FlutterLogo(size: 150),
      ),
    );
  }
}

