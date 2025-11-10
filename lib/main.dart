import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const FloreriaApp());
}

class FloreriaApp extends StatelessWidget {
  const FloreriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Florería Encanto',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Colors.pink[50],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.pinkAccent,
          foregroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// 🌸 Pantalla de carga
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", height: 150),
            const SizedBox(height: 20),
            const Text(
              "Florería Encanto",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const CircularProgressIndicator(color: Colors.white)
          ],
        ),
      ),
    );
  }
}

// 🌷 Pantalla principal
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int indice = 0;
  final List<Map<String, String>> carrito = [];
  final List<Map<String, String>> usuarios = [];

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      InicioScreen(onAgregarCarrito: (flor) {
        setState(() => carrito.add(flor));
      }),
      UsuariosScreen(usuarios: usuarios, onAgregarUsuario: (usuario) {
        setState(() => usuarios.add(usuario));
      }),
      // Pasamos onEliminar y onRealizarPedido (clear)
      CarritoScreen(
        carrito: carrito,
        onEliminar: (index) {
          setState(() => carrito.removeAt(index));
        },
        onRealizarPedido: () {
          // función para vaciar carrito desde MainScreen
          setState(() => carrito.clear());
        },
      ),
      const SeguimientoScreen(),
      const MetodoPagoScreen(),
      const ContactoScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Florería Encanto 🌸"),
        centerTitle: true,
      ),
      body: pantallas[indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indice,
        onTap: (i) => setState(() => indice = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuarios'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Carrito'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), label: 'Seguimiento'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Pago'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contact_phone), label: 'Contáctanos'),
        ],
      ),
    );
  }
}

// 🌺 Pantalla de inicio (flores)
class InicioScreen extends StatelessWidget {
  final Function(Map<String, String>) onAgregarCarrito;

  const InicioScreen({super.key, required this.onAgregarCarrito});

  final List<Map<String, String>> flores = const [
    {"nombre": "Rosas Rojas", "precio": "25", "imagen": "assets/rosas.jpg"},
    {"nombre": "Tulipanes", "precio": "30", "imagen": "assets/tulipanes.jpg"},
    {"nombre": "Lirios Blancos", "precio": "28", "imagen": "assets/lirios.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: flores.map((flor) {
        return Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Image.asset(flor["imagen"]!, height: 150, fit: BoxFit.cover),
              ListTile(
                title: Text(flor["nombre"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("S/ ${flor["precio"]}"),
                trailing: ElevatedButton(
                  onPressed: () {
                    onAgregarCarrito(flor);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${flor["nombre"]} agregado al carrito 🛒"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                  child: const Text("Agregar"),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}

// 🌼 Usuarios
class UsuariosScreen extends StatefulWidget {
  final List<Map<String, String>> usuarios;
  final Function(Map<String, String>) onAgregarUsuario;

  const UsuariosScreen(
      {super.key, required this.usuarios, required this.onAgregarUsuario});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final TextEditingController nombreCtrl = TextEditingController();
  final TextEditingController direccionCtrl = TextEditingController();

  void agregarUsuario() {
    if (nombreCtrl.text.isNotEmpty && direccionCtrl.text.isNotEmpty) {
      widget.onAgregarUsuario({
        "nombre": nombreCtrl.text,
        "direccion": direccionCtrl.text,
      });
      nombreCtrl.clear();
      direccionCtrl.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: "Nombre", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: direccionCtrl, decoration: const InputDecoration(labelText: "Dirección", border: OutlineInputBorder())),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: agregarUsuario,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                child: const Text("Agregar Usuario"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.usuarios.length,
            itemBuilder: (context, index) {
              final usuario = widget.usuarios[index];
              return Card(
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.pinkAccent),
                  title: Text(usuario["nombre"]!),
                  subtitle: Text(usuario["direccion"]!),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

// 🛒 Carrito con Realizar Pedido
class CarritoScreen extends StatelessWidget {
  final List<Map<String, String>> carrito;
  final Function(int) onEliminar;
  final VoidCallback onRealizarPedido;

  const CarritoScreen({
    super.key,
    required this.carrito,
    required this.onEliminar,
    required this.onRealizarPedido,
  });

  double _calcularTotal() {
    double total = 0;
    for (var item in carrito) {
      total += double.tryParse(item["precio"] ?? "0") ?? 0;
    }
    return total;
  }

  void _confirmarPedido(BuildContext context) {
    if (carrito.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tu carrito está vacío"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final total = _calcularTotal();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar pedido"),
        content: Text("Total: S/ ${total.toStringAsFixed(2)}\n¿Deseas realizar el pedido?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // cierra diálogo
              onRealizarPedido(); // vacía carrito via callback al MainScreen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pedido realizado con éxito 🎉"), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            child: const Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (carrito.isEmpty) {
      return const Center(child: Text("Tu carrito está vacío 🛍️", style: TextStyle(fontSize: 18, color: Colors.grey)));
    }

    final total = _calcularTotal();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carrito.length,
            itemBuilder: (context, index) {
              final flor = carrito[index];
              return ListTile(
                leading: Image.asset(flor["imagen"]!, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(flor["nombre"]!),
                subtitle: Text("S/ ${flor["precio"]}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onEliminar(index),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 8)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total: S/ ${total.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () => _confirmarPedido(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                child: const Text("Realizar Pedido"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 🚚 Seguimiento
class SeguimientoScreen extends StatelessWidget {
  const SeguimientoScreen({super.key});

  final List<Map<String, dynamic>> etapas = const [
    {"etapa": "Pedido recibido", "completado": true},
    {"etapa": "Preparando el ramo", "completado": true},
    {"etapa": "En camino", "completado": false},
    {"etapa": "Entregado", "completado": false},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: etapas.map((e) {
        final bool completado = e["completado"] == true;
        final String nombre = e["etapa"]?.toString() ?? "Etapa";
        return ListTile(
          leading: Icon(completado ? Icons.check_circle : Icons.radio_button_off, color: completado ? Colors.green : Colors.grey),
          title: Text(nombre, style: TextStyle(fontWeight: FontWeight.bold, color: completado ? Colors.black : Colors.grey[700])),
        );
      }).toList(),
    );
  }
}

// 💳 Pago
class MetodoPagoScreen extends StatelessWidget {
  const MetodoPagoScreen({super.key});

  final List<Map<String, dynamic>> metodos = const [
    {"nombre": "Tarjeta de Crédito", "icono": Icons.credit_card},
    {"nombre": "Yape / Plin", "icono": Icons.phone_android},
    {"nombre": "Pago contra entrega", "icono": Icons.delivery_dining},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: metodos.map((m) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            leading: Icon(m["icono"], color: const Color.fromARGB(255, 212, 131, 158)),
            title: Text(m["nombre"]),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Método seleccionado: ${m["nombre"]} 💳")));
            },
          ),
        );
      }).toList(),
    );
  }
}

// 📞 Contacto
class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Text(
          "📍 Dirección: Jr. Los Rosales 123, Huancayo\n"
          "📞 Teléfono: 987654321\n"
          "🌸 Gracias por confiar en Florería Encanto",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, height: 1.5),
        ),
      ),
    );
  }
}
