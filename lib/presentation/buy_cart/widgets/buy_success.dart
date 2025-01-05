import 'package:flutter/material.dart';

class BuySuccess extends StatelessWidget {
  const BuySuccess({required this.error, this.onPessedReturnHome, super.key});

  final bool error;
  final VoidCallback? onPessedReturnHome;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              error
                  ? 'Oops ocurrio un prooblema'
                  : 'Hemos recibido de tu pedido',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            if (!error)
              Text(
                'Vuelve pronto!',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPessedReturnHome,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Colors.white, width: 2),
                  ),
                ),
                child: Text(
                  'Regresar al inicio',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            if (error)
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Volver a intentar',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
