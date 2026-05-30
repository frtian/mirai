# 📋 PLANO DE DESENVOLVIMENTO - FEATURE DE NAVEGAÇÃO COM BÚSSOLA 3D

## 1. OVERVIEW DA FEATURE

A feature consiste em guiar o usuário em tempo real até um ponto de captura usando:
- **Localização GPS em tempo real** (stream contínuo)
- **Cálculo de distância e bearing** (ângulo/direção até o alvo)
- **Narração por voz** (instruções de navegação)
- **Bússola 3D animada** (seta que gira 360° apontando para o destino)

---

## 2. ARQUITETURA E ESTRUTURA (CLEAN ARCHITECTURE)

A feature será implementada em:
```
mirai/lib/modules/navigation/
├── domain/
│   ├── entities/
│   │   ├── location_entity.dart
│   │   ├── navigation_target_entity.dart
│   │   └── navigation_instruction_entity.dart
│   ├── repositories/
│   │   ├── geolocation_repository.dart
│   │   └── navigation_repository.dart
│   └── usecases/
│       ├── get_current_location_usecase.dart
│       ├── calculate_bearing_usecase.dart
│       ├── calculate_distance_usecase.dart
│       └── navigate_to_target_usecase.dart
├── data/
│   ├── datasources/
│   │   ├── geolocation_local_datasource.dart (streams GPS)
│   │   └── api_datasource.dart (mock API para pontos de captura)
│   └── repositories/
│       ├── geolocation_repository_impl.dart
│       └── navigation_repository_impl.dart
└── presentation/
    ├── pages/
    │   └── navigation_page.dart
    ├── widgets/
    │   ├── compass_3d_widget.dart
    │   ├── navigation_instruction_widget.dart
    │   └── distance_display_widget.dart
    └── controllers/
        └── navigation_controller.dart (riverpod)
```

---

## 3. BIBLIOTECAS NECESSÁRIAS

### 3.1 Geolocalização - GPS em Tempo Real
- **`geolocator`** (^11.1.0 ou superior)
  - Fornece streams contínuos de localização
  - Compatível com Flutter 3.12+
  - Suporta Android/iOS/Web
  - Requer configuração de permissões (AndroidManifest, Info.plist)

### 3.2 Text-to-Speech - Narração
- **`flutter_tts`** (^8.2.0 ou superior)
  - TTS nativo para Android/iOS
  - Suporta múltiplos idiomas e vozes
  - Compatível com Flutter 3.12+
  - Requer configuração de permissões

### 3.3 Sensores - Magnetômetro/Bússola
- **`sensors_plus`** (^7.0.0)
  - Acesso a magnetômetro para bearing em tempo real
  - Bem mantido pela Flutter Community
  - 450k+ downloads, score 140/160
  
  OU
  
- **`three_js_sensors`** (^0.2.0)
  - Integrado com Three.js (se usar 3D avançado)
  - 4.9k downloads

**Recomendação**: `sensors_plus` por ser mais estável e bem testado

### 3.4 Cálculo de Distância e Bearing
- **`haversine_distance`** (^1.2.1)
  - Cálculo de distância entre coordenadas
  - Zero dependências externas
  - Score 150/160
  
  OU
  
- **`qibla`** (^1.0.1) - **RECOMENDADO**
  - Calcula bearing (direção) com precisão geodésica
  - Calcula distância Haversine
  - Zero dependências
  - Bem testado (usado para qibla - muito crítico)
  - Score 150/160

**Recomendação**: Use `qibla` para bearing + `haversine_distance` para distância, ou apenas `qibla` se tiver todas as funções necessárias

### 3.5 Renderização 3D - Bússola Animada
**Opção A: Flame Engine (RECOMENDADO para 360° smooth)**
- **`flame`** (^1.22.0 ou posterior)
  - 87.5 score (mais alto)
  - Excelente para animações 2D/pseudo-3D
  - Perfect para bússola com seta rotativa
  - Suporta sprite sheets, rotações suaves
  - Bem documentado

**Opção B: Three.dart (se precisar verdadeiro 3D)**
- **`three_dart`** (versão compatível)
  - 51.33 score (menos otimizado que Flame)
  - Complexidade maior
  - Ideal se quiser modelo 3D real

**Recomendação**: **Flame** para prototipagem rápida + seta 2D com rotações suaves. É muito mais leve que Three.dart e suficiente para bússola.

### 3.6 State Management - Riverpod
- **`flutter_riverpod`** (^2.4.0 ou superior)
  - Gerenciamento reativo de estado
  - Injeção de dependências built-in
  - Compatível com Clean Architecture
  - 80.9 score
  - Suporta Providers (data), AsyncProvider (streams)

### 3.7 Utilitários - Equatable
- **`equatable`** (^2.0.5)
  - Value-based equality para entities
  - Essencial para Clean Architecture
  - 71.5 score

### 3.8 Persistência (Opcional)
- **`hive`** ou **`shared_preferences`** (para cachear último ponto de captura)

---

## 4. FLUXO DE DADOS

```
┌─────────────────────────────────────────────────────────────┐
│                        DOMAIN LAYER                         │
├─────────────────────────────────────────────────────────────┤
│ Entities: Location, NavigationTarget, NavigationInstruction │
│ Repositories (abstratas): GeolocationRepository, Navigation  │
│ UseCases: GetLocation, CalculateBearing, CalculateDistance  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                        DATA LAYER                           │
├─────────────────────────────────────────────────────────────┤
│ DataSources:                                                │
│   • GeolocationLocalDataSource (geolocator stream)          │
│   • MagnetometerDataSource (sensors_plus stream)            │
│   • ApiDataSource (mock API para pontos de captura)         │
│                                                             │
│ RepositoryImpl:                                              │
│   • Converte datasource → Entities via usecases             │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
├─────────────────────────────────────────────────────────────┤
│ Riverpod Providers (state management):                       │
│   • currentLocationProvider (AsyncValue<Location>)          │
│   • targetLocationProvider (AsyncValue<NavigationTarget>)   │
│   • bearingProvider (AsyncValue<double>)                    │
│   • distanceProvider (AsyncValue<double>)                   │
│   • navigationInstructionProvider (String)                  │
│                                                             │
│ Pages:                                                      │
│   • NavigationPage (orquestra widgets)                      │
│                                                             │
│ Widgets:                                                    │
│   • Compass3DWidget (Flame game ou CustomPaint)            │
│   • NavigationInstructionWidget (mostra texto + fala)      │
│   • DistanceDisplayWidget (mostra km/metros)               │
│                                                             │
│ Controllers:                                                │
│   • NavigationController (orquestra TTS)                    │
└─────────────────────────────────────────────────────────────┘
```

---

## 5. COMPONENTES TÉCNICOS DETALHADOS

### 5.1 Geolocation - Real-time Stream
```
geolocator.getPositionStream(
  LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 5, // Atualiza a cada 5 metros
  )
).listen((position) => riverpod_provider.update())
```

### 5.2 Magnetômetro - Bearing Calculation
```
sensors_plus.magnetometerEventStream.listen((event) {
  // Calcular ângulo usando quaternion ou atan2
  // Converter para bearing (0-360°)
})
```

### 5.3 Cálculo de Bearing e Distância
```dart
// Usar qibla package
import 'package:qibla/qibla.dart';

final bearing = Qibla.getDirection(
  latitude: currentLocation.latitude,
  longitude: currentLocation.longitude,
  quantizationFactor: 1, // precision
);

final distance = Qibla.getDistance(
  latitude1: currentLocation.latitude,
  longitude1: currentLocation.longitude,
  latitude2: targetLocation.latitude,
  longitude2: targetLocation.longitude,
);
```

### 5.4 Text-to-Speech - Narração
```dart
final flutterTts = FlutterTts();

await flutterTts.setLanguage("pt-BR");
await flutterTts.speak("Siga por 150 metros nessa direção");

// Ou para arquivo
await flutterTts.synthesizeToFile(
  "Vire à direita",
  "tts.wav"
);
```

### 5.5 Compass 3D - Bússola Animada

**Opção A: Flame Engine (RECOMENDADO)**
```dart
class CompassGame extends FlameGame {
  late SpriteComponent arrowSprite;
  double currentBearing = 0;
  
  @override
  Future<void> onLoad() async {
    arrowSprite = SpriteComponent(
      sprite: await loadSprite('compass_arrow.png'),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(arrowSprite);
  }
  
  @override
  void update(double dt) {
    // Animar rotação suave
    arrowSprite.angle = lerpDouble(
      arrowSprite.angle,
      currentBearing * pi / 180,
      0.1
    ) ?? 0;
  }
  
  void updateBearing(double bearing) {
    currentBearing = bearing;
  }
}
```

**Opção B: CustomPaint (mais leve)**
```dart
class CompassPainter extends CustomPainter {
  final double bearing;
  
  @override
  void paint(Canvas canvas, Size size) {
    // Desenhar círculo + seta rotacionada
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(bearing * pi / 180);
    
    // Desenhar seta aqui
  }
}
```

---

## 6. FLUXO DE NAVEGAÇÃO (Exemplo prático)

1. **Inicializar streams**:
   - Geolocalização começa
   - Magnetômetro começa
   - Usuário seleciona ponto de captura (da API mockada)

2. **Calcular em tempo real** (a cada atualização de GPS):
   - Distância até alvo
   - Bearing (ângulo) até alvo
   - Instrução de navegação

3. **Atualizar UI**:
   - Bússola gira para apontar para alvo
   - Distância atualiza
   - TTS fala instruções a cada passo

4. **Instruções de voz**:
   - "Siga por 250 metros nessa direção"
   - "Vire à direita até a seta apontar para frente"
   - "Você chegou ao ponto de captura"

---

## 7. PERMISSÕES NECESSÁRIAS

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
```

### iOS (Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Precisamos da sua localização para guiá-lo</string>
```

---

## 8. VERSÕES COMPATÍVEIS (Flutter 3.12+)

| Pacote | Versão | Score | Razão |
|--------|--------|-------|-------|
| `geolocator` | ^11.1.0 | 90.67 | Mais novo, melhor suporte |
| `flutter_tts` | ^8.2.0 | 83.75 | Compatível, bem testado |
| `sensors_plus` | ^7.0.0 | 87.5 | Bem mantido pela comunidade |
| `qibla` | ^1.0.1 | 85.9 | Zero deps, geodésica |
| `haversine_distance` | ^1.2.1 | 85.33 | Simples e confiável |
| `flame` | ^1.22.0 | 87.5 | Melhor para 2D/pseudo-3D |
| `flutter_riverpod` | ^2.4.0 | 80.9 | State management moderno |
| `equatable` | ^2.0.5 | 71.5 | Value equality |

---

## 9. DECISÕES ARQUITETURAIS

✅ **Usar Flame** para bússola em vez de Three.dart
- Muito mais leve
- Perfeitamente adequado para bússola 2D/3D pseudo
- Melhor score e documentação

✅ **Usar Riverpod Providers para streams**
```dart
final currentLocationProvider = StreamProvider((ref) {
  return Geolocator.getPositionStream(...);
});
```

✅ **Usar qibla para cálculos geodésicos**
- Zero dependências externas
- Muito preciso
- Bem testado

✅ **Separar TTS em controller**
- NavigationController gerencia fala
- Não fala continuamente, apenas em eventos importantes

✅ **Cache de ponto de captura**
- Se usar Hive, cachear último ponto
- Reduz chamadas à API mockada

---

## 10. CONSIDERAÇÕES DE PERFORMANCE

- **Distancefilter**: 5-10 metros (não atualizar UI a cada centímetro)
- **LocationAccuracy**: `high` (mas consome bateria)
- **Flame game loop**: 60 FPS (animação suave)
- **TTS**: Não falar constantemente (apenas mudanças)
- **Streams**: Usar `.where()` para filtrar atualizações desnecessárias

---

## 11. PRÓXIMOS PASSOS (ORDEM RECOMENDADA)

1. **Setup de dependências** e permissões
2. **Domain layer** (entities, repositories abstratas, usecases)
3. **Data layer** (datasources, repository implementations)
4. **Riverpod providers** (state management)
5. **Compass3DWidget** com Flame
6. **NavigationInstructionWidget** com TTS
7. **NavigationPage** (orquestração)
8. **Testes unitários** (mocking de GPS/magnetômetro)
9. **Testes de integração** (navegação end-to-end)

---

## 12. OBSERVAÇÕES FINAIS

- A feature é **totalmente viável** com stack atual
- **Flame é melhor que Three.dart** para esse caso de uso
- **Riverpod é ideal** para gerenciar múltiplos streams
- **Qibla é a melhor escolha** para cálculos geodésicos
- **TTS nativo é suficiente** (não precisa de modelos ML)
- **Mockear API** com `@riverpod` é simples

Essa arquitetura garante:
- ✅ Clean Architecture respeitada
- ✅ Testabilidade alta
- ✅ Reutilização entre módulos
- ✅ Performance otimizada
- ✅ Stack de tecnologia de ponta
