import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic> questoes = [];
  int indice = 0;
  int pontuacao = 0;
  bool respondeu = false;
  int? selecionada;

  @override
  void initState() {
    super.initState();
    carregarMockupJSON();
  }

  Future<void> carregarMockupJSON() async {
    String dados =
        await rootBundle.loadString('assets/mockup/quiz.json');

    setState(() {
      questoes = json.decode(dados);
    });
  }

  void responder(int escolha) {
    if (respondeu) return;

    setState(() {
      respondeu = true;
      selecionada = escolha;

      if (escolha == questoes[indice]['resposta']) {
        pontuacao++;
      }
    });
  }

  void proxima() {
    setState(() {
      indice++;
      respondeu = false;
      selecionada = null;
    });
  }

  Color corBotao(int i) {
    if (!respondeu) return const Color(0xFF9C8CE7);

    if (i == questoes[indice]['resposta']) {
      return Colors.green;
    }

    if (i == selecionada) {
      return Colors.red;
    }

    return const Color(0xFF9C8CE7);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quiz de Filosofia")),

      body: questoes.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : indice >= questoes.length
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/imagens/logo.png',
                        height: 120,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Pontuação: $pontuacao / ${questoes.length}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),

                      Text(
                        "Questão ${indice + 1}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),

                      const SizedBox(height: 20),

                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF9C8CE7),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey[200],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  questoes[indice]['imagem'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            const SizedBox(height: 15),

                            Text(
                              questoes[indice]['pergunta'],
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 15),

                            ...List.generate(
                              questoes[indice]['alternativas'].length,
                              (i) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: corBotao(i),
                                    ),
                                    onPressed: () => responder(i),
                                    child: Text(
                                      questoes[indice]['alternativas'][i],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: indice > 0
                                ? () => setState(() {
                                      indice--;
                                    })
                                : null,
                            child: const Text("Anterior"),
                          ),
                          ElevatedButton(
                            onPressed: respondeu
                                ? proxima
                                : null,
                            child: const Text("Próxima"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}