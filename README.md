# Hugo Madeira - Jogo Hack and Slash 3D

## Visão Geral
Jogo 3D do gênero **Hack and Slash** desenvolvido na engine **Godot 4.6**.

## Escopo
- **Gênero:** Hack and Slash (combate corpo a corpo com foco em ação)
- **Perspectiva:** 3D terceira pessoa
- **Engine:** Godot 4.6 (Forward Plus)
- **Estilo Inicial:** Protótipo com formas geométricas simples (cubos, esferas, cilindros)
- **Evolução:** Modelos 3D detalhados serão criados posteriormente

## Fase Atual
- **Prototipagem com formas geométricas simples**
- Foco em mecânicas básicas de gameplay
- Testes de combate, movimento e câmera
- Assets temporários são primitivas 3D com cores sólidas

## Progresso Atual

### ✅ Implementado
- **Personagem Principal (Player)**
  - CharacterBody3D com colisão (box)
  - Movimento WASD/Setas
  - Câmera terceira pessoa com pivot
  - Sistema de vida com getter/setter
  - Controllers modulares (POO)

- **Controllers (Arquitetura POO)**
  - `MovementController` - Movimento, pulo, gravidade
  - `InteractionController` - Interação com objetos próximos
  - `AttackController` - Sistema de ataques com herança
	- `BaseAttack` (classe base)
	- `LightAttack` (ataque leve, 10 dmg)
	- `HeavyAttack` (ataque pesado, 25 dmg)
	- `JumpAttack` (ataque aéreo, 20 dmg)

- **Cenário (Main Scene)**
  - Chão plano 50x50 com colisão
  - Obstáculos: 2 boxes, 1 cilindro, 1 esfera, 1 plataforma
  - Iluminação direcional + ambiente
  - Todos objetos com StaticBody3D + CollisionShape3D

### 🚧 Em Desenvolvimento
- [ ] Aplicação de texturas/materiais
- [ ] Animações de ataque
- [ ] Inimigos básicos
- [ ] Sistema de combo
- [ ] HUD (vida, stamina)

### 📋 Planejado
- [ ] IA de inimigos
- [ ] Sistema de dano por área
- [ ] Sons de combate
- [ ] Menu principal
- [ ] Sistema de save/load

## Controles
| Ação | Teclado | Gamepad |
|------|---------|---------|
| Mover | WASD | Analógico Esquerdo |
| Câmera | Setas | Analógico Direito |
| Pular | 3 | Botão A |
| Interagir | 4 | Botão X |
| Ataque Leve | 1 | Botão B |
| Ataque Pesado | 2 | Botão Y |

## Estrutura do Projeto
```
hugo-madeira/
├── project.godot
├── icon.svg
├── README.md
├── scenes/
│   ├── main.tscn          # Cena principal com cenário
│   └── player.tscn        # Cena do personagem
└── scripts/
	├── player.gd           # Script principal do jogador
	└── controllers/
		├── movement_controller.gd      # Movimento e pulo
		├── interaction_controller.gd   # Interação com objetos
		└── attack_controller.gd        # Sistema de ataques
```

## Arquitetura
- **POO completa** com herança, encapsulamento e polimorfismo
- **Composição** via controllers acoplados ao Player
- **class_name** para reutilização de classes
- **Propriedades** com getters/setters para controle de estado

## Notas
- Este documento serve como contexto para IAs assistentes
- Manter sempre atualizado com o progresso do jogo
- Assets temporários são formas geométricas básicas com cores sólidas
- Assets finais serão adicionados em fases posteriores
