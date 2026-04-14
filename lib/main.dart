import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen>
    with SingleTickerProviderStateMixin {

  List<String> quotes = [
    "Believe in yourself!",
    "Stay positive, work hard, make it happen.",
    "Don’t stop until you’re proud.",
    "Dream big and dare to fail.",
    "Success is not final, failure is not fatal.",
    "Push yourself, because no one else will do it for you.",
    "Great things never come from comfort zones."
  ];

  String currentQuote = "Tap below to generate a quote 💡";

  // 🔥 NEW: Store generated quotes
  List<String> storedQuotes = [];

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  void generateQuote() {
    final random = Random();
    String newQuote = quotes[random.nextInt(quotes.length)];

    setState(() {
      currentQuote = newQuote;

      // Store quote if not already added
      if (!storedQuotes.contains(newQuote)) {
        storedQuotes.add(newQuote);
      }
    });

    _controller.forward(from: 0);
  }

  // 🔥 NEW: Open stored quotes screen
  void openStoredQuotes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoredQuotesScreen(quotes: storedQuotes),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // 🔥 NEW: AppBar with button
      appBar: AppBar(
        title: Text("Quote Generator"),
        backgroundColor: Colors.white38,
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: openStoredQuotes,
          )
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Glass Card
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Text(
                          currentQuote,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Generate Button
                ElevatedButton(
                  onPressed: generateQuote,
                  style: ElevatedButton.styleFrom(
                    padding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    "New Quote",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // 🔥 NEW: View Stored Quotes Button
                ElevatedButton.icon(
                  onPressed: openStoredQuotes,
                  icon: Icon(Icons.folder),
                  label: Text("View Stored Quotes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🔥 NEW SCREEN
class StoredQuotesScreen extends StatelessWidget {
  final List<String> quotes;

  StoredQuotesScreen({required this.quotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stored Quotes 📜"),
        backgroundColor: Colors.deepPurple,
      ),
      body: quotes.isEmpty
          ? Center(
        child: Text(
          "No quotes generated yet!",
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: quotes.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(quotes[index]),
            ),
          );
        },
      ),
    );
  }
}