import 'package:ecoheroes/provider/publicationsprovider.dart';
import 'package:ecoheroes/ui/to_appbar.dart';
import 'package:ecoheroes/ui/to_colorbutton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TOSuccessPublication extends StatelessWidget {
  const TOSuccessPublication({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final publicationProvider =
        Provider.of<PublicationsProvider>(context, listen: false);
        
    return Scaffold(
      body: Column(
        children: [
          TOAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 150),
                    Container(
                      child: Image.asset('assets/noun_check_circle.png'),
                    ),
                    SizedBox(height: 30),
                    Container(
                      child: Text(
                        '¡Tu post ha sido compartido!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                        textScaleFactor: 1.0,
                      ),
                    ),
                    SizedBox(height: 30),
                    TOColorButton(
                      onPressed: () async {
                        await publicationProvider.getPublications();
                        publicationProvider.setDisplayAddButton();
                        Navigator.pop(context);
                      },
                      color: Color(0xFF163B4D),
                      radius: Radius.circular(50),
                      text: Text(
                        'Entendido!',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
