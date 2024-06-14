import 'package:flutter/material.dart';
import 'package:phone_book_app/models/entree.dart';

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
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.phone_outlined,
                  color: Color.fromRGBO(3, 148, 222, 1),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
