# Hugo Madeira - Jogo Hack and Slash 3D

## Visão Geral
Jogo 3D do gênero **Hack and Slash** desenvolvido na engine **Godot 4.6**.

## Escopo
- **Gênero:** Hack and Slash (combate corpo a corpo com foco em ação)
- **Perspectiva:** 3D terceira pessoa
- **Engine:** Godot 4.6 (Forward Plus, Jolt Physics)
- **Estilo Inicial:** Protótipo com formas geométricas simples (cubos, esferas, cilindros)
- **Evolução:** Modelos 3D detalhados serão criados posteriormente

## Progresso Atual

### ✅ Implementado

#### Personagem Principal (Player)
- [x] CharacterBody3D com colisão (box)
- [x] Sistema de vida com getter/setter (encapsulamento)
- [x] Câmera terceira pessoa com pivot
- [x] Rotação de câmera horizontal e vertical (limitada a ±60°)
- [x] Arquitetura modular com controllers (composição)

#### Controllers (Arquitetura POO)
- [x] **InputController** - Centraliza todos os inputs (teclado + gamepad)
  - Movimento: WASD (teclado) + Analógico esquerdo (gamepad)
  - Câmera: Setas (teclado) + Analógico direito (gamepad)
  - Ações: Teclas 1-2-3-4 (estilo WoW) + Botões A/B/X/Y (gamepad)
  - Deadzone configurável para analógicos
  - Sensibilidade ajustável para câmera
  - Métodos combinados `is_any_*` (teclado OU gamepad)

- [x] **MovementController** - Movimento, pulo e gravidade
  - Movimento com WASD/Setas ou analógico esquerdo
  - Sistema de pulo com verificação de chão
  - Gravidade realista (9.8 m/s²)
  - Desaceleração suave
  - Usa InputController com fallback

- [x] **InteractionController** - Interação com objetos próximos
  - Raycast para detectar objetos interagíveis
  - Range de interação configurável
  - Cooldown entre interações
  - Sistema de detecção de objetos com método `interact()`

- [x] **AttackController** - Sistema de ataques com herança
  - `BaseAttack` (classe base com damage, cooldown, range)
  - `LightAttack` (ataque leve, 10 dmg, 0.3s cooldown)
  - `HeavyAttack` (ataque pesado, 25 dmg, 0.8s cooldown)
  - `JumpAttack` (ataque aéreo, 20 dmg, 0.6s cooldown)
  - Sistema de combo (registrado e resetado por timer)
  - Cooldown entre ataques

#### Cenário (Main Scene)
- [x] Chão plano 50x50 com colisão (StaticBody3D + BoxShape3D)
- [x] Obstáculos com colisão:
  - 2 Boxes (vermelho e azul)
  - 1 Cilindro (amarelo)
  - 1 Esfera (roxo)
  - 1 Plataforma elevada (cinza)
- [x] Iluminação:
  - DirectionalLight3D com sombras
  - OmniLight3D (luz ambiente)
- [x] Materiais com cores sólidas (StandardMaterial3D + albedo)

#### Controles
| Ação | Teclado | Gamepad |
|------|---------|---------|
| Mover | WASD | Analógico Esquerdo |
| Câmera | Setas | Analógico Direito |
| Ataque Leve | 1 | Botão B |
| Ataque Pesado | 2 | Botão Y |
| Pular | 3 | Botão A |
| Interagir | 4 | Botão X |

### 🚧 Em Desenvolvimento
- [ ] Aplicação de texturas (imagens) nos materiais
- [ ] Animações de ataque e movimento
- [ ] Inimigos básicos com IA
- [ ] Sistema de dano por área
- [ ] HUD (vida, stamina, combo)

### 📋 Planejado
- [ ] IA de inimigos com pathfinding
- [ ] Sons de combate e ambiente
- [ ] Menu principal
- [ ] Sistema de save/load
- [ ] Múltiplas fases

## Estrutura do Projeto
```
hugo-madeira/
├── project.godot              # Configurações do projeto (inputs, física, etc)
├── icon.svg                   # Ícone do projeto
├── README.md                  # Documentação do projeto
├── scenes/
│   ├── main.tscn              # Cena principal com cenário
│   └── player.tscn            # Cena do personagem (box + câmera)
└── scripts/
    ├── player.gd               # Script principal do jogador
    └── controllers/
        ├── input_controller.gd       # Centraliza inputs (teclado + gamepad)
        ├── movement_controller.gd    # Movimento, pulo e gravidade
        ├── interaction_controller.gd # Interação com objetos
        └── attack_controller.gd      # Sistema de ataques com herança
```

## Arquitetura

### POO Completa
- **Herança:** `BaseAttack` → `LightAttack`, `HeavyAttack`, `JumpAttack`
- **Encapsulamento:** Variáveis privadas (`_health`, `_can_attack`) com getters/setters
- **Polimorfismo:** Métodos sobrescritos nas classes filhas
- **Composição:** Player usa controllers como componentes
- **class_name:** Todas as classes são nomeadas para reutilização

### Padrão de Controllers
```
Player (CharacterBody3D)
├── InputController          ← Centraliza todos os inputs
├── MovementController       ← Delega movimento
├── InteractionController    ← Delega interação
└── AttackController         ← Delega ataques
```

### Fluxo de Input
```
Teclado/Gamepad → InputController → Player → Controller específico → Ação
```

## Configurações do Projeto
- **Física:** Jolt Physics
- **Renderer:** Forward Plus
- **Versão:** Godot 4.6
- **Branch:** main

## Como Testar
1. Abra o projeto no Godot 4.6
2. Pressione **F5** para rodar em modo debug
3. Use **WASD** para mover e **Setas** para câmera (ou gamepad)
4. Teste os ataques com **1** e **2**

## Notas
- Este documento serve como contexto para IAs assistentes
- Manter sempre atualizado com o progresso do jogo
- Assets temporários são formas geométricas básicas com cores sólidas
- Assets finais serão adicionados em fases posteriores
