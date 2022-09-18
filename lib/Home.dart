import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _addressController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  FirebaseStorage storage = FirebaseStorage.instance;
  XFile? image;
  Future getImagefromcamera() async {
    image = await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      image = image;
    });
  }

  Future getImagefromGallery() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      image = image;
    });
  }

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('Product');

  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _nameController.text = documentSnapshot['name'];
      // _addressController.text = documentSnapshot['address'];
      _imageController.text = documentSnapshot['image'];
      _priceController.text = documentSnapshot['price'].toString();
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                // TextField(
                //   controller: _addressController,
                //   decoration: const InputDecoration(labelText: 'Address'),
                // ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: (image != null)
                      ? Container(
                          margin: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(image!.path)),
                              fit: BoxFit.fill,
                            ),
                          ))
                      : Container(
                          // color: Colors.green,
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.green
                              // image: DecorationImage(
                              //  image: Image.asset('name')
                              // ),
                              ),
                        ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () async {
                            getImagefromGallery();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.upload_file,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Upload file',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            getImagefromcamera();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt,
                                  color: Colors.black,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                Spacer(
                  flex: 2,
                ),
                // Center(
                //   child: Text(
                //     "ADD",
                //     style: TextStyle(
                //         color: Colors.grey[800], fontWeight: FontWeight.w500),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: Text(action == 'create' ? 'Create' : 'Update'),
                  onPressed: () async {
                    final String? name = _nameController.text;
                    final double? price =
                        double.tryParse(_priceController.text);
                    // final String? address = _addressController.text;
                    if (name != null && price != null && image != null) {
                      if (action == 'create') {
                        // Persist a new product to Firestore
                        await _products.add(
                            {"name": name, "price": price, "image": image});
                      }

                      if (action == 'update') {
                        // Update the product
                        await _products.doc(documentSnapshot!.id).update(
                            {"name": name, "price": price, "image": image});
                      }

                      // Clear the text fields
                      _nameController.text = '';
                      _priceController.text = '';
                      image=null;
                      // _addressController.text = '';
                      // Hide the bottom sheet
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  // Deleteing a product by id
  Future<void> _deleteProduct(String productId) async {
    await _products.doc(productId).delete();

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD FIRESTORE'),
      ),
      // Using StreamBuilder to display all products from Firestore in real-time
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text(documentSnapshot['image']),
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['price'].toString()),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          // Press this button to edit a single product
                          IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () =>
                                  _createOrUpdate(documentSnapshot)),
                          // This icon button is used to delete a single product
                          IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  _deleteProduct(documentSnapshot.id)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // Add new product
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createOrUpdate(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
