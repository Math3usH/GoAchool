# 🚌 goSchool — Monitoramento de Transporte Escolar

Aplicativo Flutter para monitoramento em tempo real de crianças no transporte escolar.

---

## 📱 Funcionalidades

### 👨‍👩‍👧 Painel do Responsável
- **Confirmação diária** — toggle para confirmar se o filho vai à escola
- **Rastreamento ao vivo** — mapa com posição da van em tempo real
- **ETAs** — horário estimado de chegada na escola e de busca à tarde
- **Status em tempo real** — se o filho está a bordo, com progresso da rota
- **Alertas automáticos** — desvio de rota, embarque, desembarque
- **Notificações** — histórico completo de eventos do dia
- **Histórico** — registro de todas as viagens do mês

### 🚐 Painel do Motorista
- **Cadastro de alunos** — nome, turma, endereço, telefone do responsável
- **Rota otimizada** — geração automática da melhor rota do dia
- **Checklist embarque** — confirmar ✅ ou marcar ausência ❌ de cada aluno
- **Checklist desembarque** — confirmar saída na escola
- **Resumo do dia** — quantos embarcaram, faltaram, pendentes

---

## 🚀 Como rodar

### Pré-requisitos
- Flutter 3.x instalado ([flutter.dev](https://flutter.dev))
- Android Studio ou VS Code com extensão Flutter
- Dispositivo/emulador Android ou iOS

### Passos

```bash
# 1. Acesse a pasta do projeto
cd goschool

# 2. Instale as dependências
flutter pub get

# 3. Execute o app
flutter run
```

### Para Android (release APK)
```bash
flutter build apk --release
# APK gerado em: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🗺️ Integrar Google Maps (opcional)

1. Acesse [console.cloud.google.com](https://console.cloud.google.com)
2. Crie um projeto e ative **Maps SDK for Android/iOS**
3. Gere uma chave de API

**Android** — edite `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_CHAVE_AQUI"/>
```

**iOS** — edite `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("SUA_CHAVE_AQUI")
```

Depois substitua `MapaPlaceholder` por `GoogleMap(...)` nos arquivos:
- `lib/screens/responsavel/rastreamento_tab.dart`
- `lib/screens/motorista/rota_tab.dart`

---

## 🗄️ Banco de Dados Local (SQLite)

O app usa **sqflite** (SQLite local), sem necessidade de servidor externo.

Tabelas criadas automaticamente:
| Tabela | Descrição |
|--------|-----------|
| `alunos` | Cadastro de alunos |
| `checklist` | Registro diário de embarque/desembarque |
| `viagens` | Histórico de viagens |

Para usar com XAMPP/MySQL no futuro, substitua `DatabaseService` por chamadas HTTP ao seu backend PHP.

---

## 📁 Estrutura do projeto

```
lib/
├── main.dart                          # Entry point
├── theme/
│   └── app_theme.dart                 # Cores e tema global
├── models/
│   └── models.dart                    # Aluno, Notificacao, CheckStatus...
├── services/
│   ├── app_state.dart                 # Estado global (Provider)
│   └── database_service.dart          # SQLite (sqflite)
├── widgets/
│   └── widgets.dart                   # Componentes reutilizáveis
└── screens/
    ├── login_screen.dart              # Tela de login
    ├── responsavel/
    │   ├── responsavel_screen.dart    # Shell com tabs
    │   ├── rastreamento_tab.dart      # Mapa + status
    │   ├── notificacoes_tab.dart      # Lista de notificações
    │   └── historico_tab.dart         # Histórico de viagens
    └── motorista/
        ├── motorista_screen.dart      # Shell com tabs
        ├── alunos_tab.dart            # Cadastro de alunos
        ├── rota_tab.dart              # Rota otimizada
        └── checklist_tab.dart         # Embarque/desembarque
```

---

## 🔧 Tecnologias

| Pacote | Uso |
|--------|-----|
| `provider` | Gerenciamento de estado |
| `sqflite` | Banco de dados local SQLite |
| `google_maps_flutter` | Integração Google Maps |
| `flutter_local_notifications` | Notificações push locais |
| `geolocator` | GPS em tempo real |
| `intl` | Formatação de datas em pt-BR |

---

## 📌 Próximos passos para produção

- [ ] Autenticação real (Firebase Auth ou JWT)
- [ ] Backend com XAMPP/PHP + MySQL
- [ ] GPS real da van via `geolocator`
- [ ] WebSockets para localização em tempo real
- [ ] Notificações push com Firebase FCM
- [ ] Google Maps com rotas reais (Directions API)
- [ ] App para iOS e Android nas stores
