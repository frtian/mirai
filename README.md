
![Logo Arara](assets/images/logo.png)
### Acompanhamento Remoto de Áreas em Recuperação Ambiental

## 🌟 O Projeto
O **ARARA** é uma solução tecnológica desenvolvida para transformar o monitoramento de áreas degradadas em recuperação no estado do Tocantins. Através de um modelo de **monitoramento colaborativo**, o projeto permite que proprietários rurais tornem-se agentes ativos na coleta de evidências, enquanto a **SEMARH** e engenheiros florestais mantêm a supervisão e validação técnica de forma remota e inteligente.

### 🚩 O Problema
Atualmente, o monitoramento depende de visitas presenciais semestrais, gerando:
- **Alto custo** para o proprietário rural (diárias técnicas elevadas).
- **Gargalo operacional** para profissionais e órgãos ambientais.
- **Identificação tardia** de problemas como erosão ou mortalidade de mudas.

### ✅ A Solução
Um ecossistema composto por um **aplicativo móvel offline** (para o proprietário) e uma **plataforma web** (para análise técnica), reduzindo deslocamentos desnecessários e priorizando vistorias presenciais com base em evidências orientadas por dados.

---

## 🚀 Funcionalidades Principais (MVP)
- **Login Simplificado:** Acesso via código OTP de 6 dígitos.
- **Captura Offline:** Registro de fotos georreferenciadas (latitude, longitude, altitude) mesmo em áreas sem sinal de internet.
- **Fluxo de Navegação:** Bússola em tempo real que guia o usuário até os pontos amostrais de captura.
- **Mapas Offline:** Sistema de cache automático que permite visualizar rotas e pontos sem conexão.
- **Sincronização Inteligente:** Envio automático das evidências para o servidor assim que uma conexão é detectada.
- **Branding Institucional:** Interface moderna, limpa e adaptada aos padrões de acessibilidade e usabilidade do campo.

---

## 📱 Plataformas Suportadas
O ARARA é uma solução multiplataforma construída com Flutter, operando em:
- **Android** (Otimizado)
- **iOS** (Otimizado)
- **Web** (Funcional, mas com limitações)

> **Nota sobre a versão Web:** Embora o projeto compile para Web, ele foi projetado e otimizado especificamente para o contexto **mobile**. Algumas funcionalidades que dependem de hardware específico (como sensores de magnetômetro para a bússola e APIs de câmera nativa) ou o layout adaptado para telas pequenas podem não funcionar perfeitamente em navegadores desktop.

---

## 🛠️ Tecnologia e Arquitetura
O projeto foi construído utilizando as melhores práticas de engenharia de software:
- **Flutter & Dart:** Para uma experiência mobile fluida e performática.
- **Clean Architecture:** Divisão clara em camadas (*Data, Domain, Presentation*) para facilitar a manutenção e escalabilidade.
- **Riverpod:** Gerência de estado moderna e robusta.
- **Drift (SQLite):** Persistência de dados local para operação 100% offline.
- **Leaflet (flutter_map):** Mapas interativos com sistema de cache personalizado.

---

## 🤖 Uso de Inteligência Artificial
Este projeto foi desenvolvido utilizando a metodologia **Spec-Driven Development (SDD)** com o auxílio de inteligência artificial avançada. 
- **Brainstorming Expandido:** A IA foi utilizada para explorar cenários, refinar requisitos e propor fluxos de decisão técnica.
- **Implementação Assistida:** O código foi gerado e refinado através de diretrizes técnicas rigorosas, garantindo produtividade sem comprometer a qualidade arquitetural.

---

## 📦 Como Rodar o Projeto

### Pré-requisitos
- Flutter SDK (^3.12.0)
- Dart SDK
- Android Studio / VS Code com plugins Flutter/Dart

### Instalação
1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/mirai.git
   ```
2. Instale as dependências:
   ```bash
   flutter pub get
   ```
3. Execute o build_runner para gerar os arquivos do banco de dados:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. Rode o aplicativo:
   ```bash
   flutter run
   ```

---

## 👥 Responsabilidade Social e Ambiental
O ARARA não substitui o trabalho técnico do engenheiro florestal; ele o potencializa. Ao criar uma ponte digital entre o campo e a SEMARH, garantimos que a recuperação ambiental do Tocantins seja mais rápida, transparente e eficiente.

**Desenvolvido por Arara 2026₢**  
*Hackathon: Tecnologia para uma Gestão Ambiental Acessível, Eficiente e Orientada por Dados.*
