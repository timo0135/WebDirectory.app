import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_book_app/models/entree.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:phone_book_app/screens/entree_details.dart';

class EntreePreview extends StatefulWidget {
  final Entree entree;
  const EntreePreview({super.key, required this.entree});

  @override
  _EntreePreviewState createState() => _EntreePreviewState();
}

class _EntreePreviewState extends State<EntreePreview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
            ),
          ],
        ),
        // ! Affichage des informations de l'entrée
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.entree.image),
            backgroundColor: Colors.white,
          ),
          title: Text('${widget.entree.nom} ${widget.entree.prenom}'),
          subtitle: Text(widget.entree.departement.join(', ')),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.mail_outline,
                  color: Color.fromRGBO(3, 148, 222, 1),
                ),
                onPressed: () {
                  _sendEmail(widget.entree.email!);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.phone_outlined,
                  color: Color.fromRGBO(3, 148, 222, 1),
                ),
                onPressed: () {
                  _callNumber(widget.entree.numeroTel1!);
                },
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EntreeDetails(urlEntree: widget.entree.id!)));
          },
        ),
      ),
    );
  }

  // ! Fonctions pour lancer un appel 
  Future<void> _callNumber(String num) async {
    final Uri tel = Uri.parse("tel:$num");

    await launchUrl(tel)
        ? ''
        : throw Exception('Impossible de lancer l\'appel $tel');
  }

  // ! Fonctions pour envoyer un email 
  Future<void> _sendEmail(String email) async {
    final Uri mail = Uri.parse("mailto:$email");

    await launchUrl(mail)
        ? ''
        : throw Exception('Impossible de lancer l\'email $mail');
  }
}
