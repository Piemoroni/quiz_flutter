import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../root/pallet.dart';

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
    carregarJSON();
  }

  Future<void> carregarJSON() async {
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
    if (!respondeu) return Palette.secondary;

    if (i == questoes[indice]['resposta']) {
      return Palette.correct;
    }

    if (i == selecionada) {
      return Palette.wrong;
    }

    return Palette.secondary;
  }

  @override
  Widget build(BuildContext context) {
    if (questoes.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (indice >= questoes.length) {
      return Scaffold(
        appBar: AppBar(title: const Text("Resultado")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/imagens/logo.png',
                height: 120,
              ),

              const SizedBox(height: 20),

              Text(
                "Quiz Finalizado!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Palette.primary,
                ),
              ),

              const SizedBox(height: 15),

              Text(
                "Pontuação: $pontuacao / ${questoes.length}",
                style: TextStyle(
                  fontSize: 20,
                  color: Palette.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    var q = questoes[indice];

    return Scaffold(
      appBar: AppBar(title: const Text("Quiz de Filosofia")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),

            Text(
              "Questão ${indice + 1}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Palette.primary, 
              ),
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    q['imagem'],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                q['pergunta'],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.primary, 
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...List.generate(q['alternativas'].length, (i) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corBotao(i),
                  ),
                  onPressed: () => responder(i),
                  child: Text(q['alternativas'][i]),
                ),
              );
            }),

            const SizedBox(height: 20),

            if (respondeu)
              ElevatedButton(
                onPressed: proxima,
                child: const Text("Próxima"),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}