import 'dart:io';

void main() async {
  print('🚀 Iniciando Flutter Watcher Customizado...');

  // Inicia o Flutter forçando o uso do Shell (o que resolve o bug do .bat no Windows)
  final process = await Process.start(
    'flutter',
    ['run'], // Se tiver mais de um device, troque por ['run', '-d', 'android']
    runInShell: true,
  );

  // Redireciona os logs do Flutter para o terminal do Zed
  process.stdout.listen(stdout.add);
  process.stderr.listen(stderr.add);

  // Fica escutando a pasta lib/
  final dir = Directory('lib');
  DateTime? lastReload;

  dir.watch(recursive: true).listen((event) {
    // Só dispara se for um arquivo Dart
    if (event.path.endsWith('.dart')) {
      final now = DateTime.now();

      // Debounce simples de 500ms para o watcher não disparar várias vezes
      // caso a IDE salve o arquivo em frações de segundo
      if (lastReload == null ||
          now.difference(lastReload!).inMilliseconds > 500) {
        print('\n⚡ Arquivo salvo. Disparando Hot Reload...');
        // "Digita" a letra r no terminal do Flutter rodando em segundo plano
        process.stdin.write('r');
        lastReload = now;
      }
    }
  });
}
