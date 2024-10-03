import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter GestureDetector',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  final Icon circuloAzul = Icon(
    Icons.circle_outlined,
    color: Colors.blue,
    size: 90,
  );

  final Icon xVermelho = Icon(
    Icons.close,
    color: Colors.red,
    size: 90,
  );

  int contador = 0;

  String mensagem = '';

  bool fimDeJogo = false;

  //Matriz
  List<List<Icon?>> gridState = List.generate(3, (_) => List.filled(3, null));

  bool matrizCompleta() {
    for (var row in gridState) {
      for (var cell in row) {
        if (cell == null) {
          return false;
        }
      }
    }
    return true;
  }

  bool verificarLinha({marcador, posicao}) {
    int contador = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (gridState[row][col] == marcador) {
          if (row == posicao) {
            contador++;
          }
        }
      }
    }

    if (contador == 3) {
      return true;
    }
    return false;
  }

  bool verificarColuna({marcador, posicao}) {
    int contador = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (gridState[row][col] == marcador) {
          if (col == posicao) {
            contador++;
          }
        }
      }
    }

    if (contador == 3) {
      return true;
    }
    return false;
  }

  bool verificarTransversal1({marcador}) {
    int contador = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (gridState[row][col] == marcador) {
          if (row == col) {
            contador++;
          }
        }
      }
    }

    if (contador == 3) {
      return true;
    }
    return false;
  }

  bool verificarTransversal2({marcador}) {
    int contador = 0;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (gridState[row][col] == marcador) {
          if (row + col == 2) {
            contador++;
          }
        }
      }
    }

    if (contador == 3) {
      return true;
    }
    return false;
  }

  bool verificarTodasPossibilidades(marcador) {
    List<bool> vitoria = [];
    vitoria.add(verificarTransversal1(marcador: marcador));
    vitoria.add(verificarTransversal2(marcador: marcador));
    for (var i = 0; i < 3; i++) {
      vitoria.add(verificarLinha(marcador: marcador, posicao: i));
      vitoria.add(verificarColuna(marcador: marcador, posicao: i));
    }

    if (vitoria.any((element) => element == true)) {
      return true;
    } else {
      return false;
    }
  }

  void decidirVencedor() {
    bool xGanhou = verificarTodasPossibilidades(xVermelho);
    bool circuloGanhou = verificarTodasPossibilidades(circuloAzul);

    if (fimDeJogo) {
      return;
    }

    if (xGanhou) {
      setState(() {
        mensagem = 'O jogador com o X ganhou!';
        fimDeJogo = true;
      });
    }
    if (circuloGanhou) {
      setState(() {
        mensagem = 'O jogador com o circulo ganhou!';
      });
      fimDeJogo = true;
    }
    if (!circuloGanhou && !xGanhou && matrizCompleta()) {
      setState(() {
        mensagem = 'Empate!';
      });
      fimDeJogo = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jogo da velha'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Jogador atual: ',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${contador.isEven ? 'Circulo' : 'X'}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: contador.isEven ? Colors.blue : Colors.red)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            flex: 4,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final row = index ~/ 3;
                final col = index % 3;
                return GestureDetector(
                  onTap: () {
                    // print('$row,$col');
                    if (!fimDeJogo) {
                      if (gridState[row][col] == null) {
                        setState(() {
                          gridState[row][col] =
                              contador.isEven ? circuloAzul : xVermelho;
                          contador++;
                        });
                      }
                      decidirVencedor();
                    }
                  },
                  child: Container(
                    child: gridState[row][col],
                    decoration: BoxDecoration(
                        border: Border.all(), color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Text(mensagem, style: TextStyle(fontSize: 20)),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      style: TextButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        setState(() {
                          fimDeJogo = false;
                          mensagem = '';
                          contador = 0;
                          gridState =
                              List.generate(3, (_) => List.filled(3, null));
                        });
                      },
                      child: Text(
                        'Tentar novamente',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
