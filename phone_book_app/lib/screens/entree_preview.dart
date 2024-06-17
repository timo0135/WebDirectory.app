import 'package:flutter/material.dart';
import 'package:phone_book_app/models/entree.dart';
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
                  widget.entree.sendEmail(widget.entree.email!);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.phone_outlined,
                  color: Color.fromRGBO(3, 148, 222, 1),
                ),
                onPressed: () {
                  widget.entree.callNumber(widget.entree.numeroTel1!);
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
  
}
