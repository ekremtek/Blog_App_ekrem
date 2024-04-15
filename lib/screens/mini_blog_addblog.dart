import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  final _formKey = GlobalKey<FormState>();
  late String blogTitle;
  late String blogContent;
  late String author;
  XFile? selectedImage;

  void _submit() async {
    if (selectedImage != null) {
      Uri url = Uri.parse("https://tobetoapi.halitkalayci.com/api/Articles");

      var request = http.MultipartRequest("POST", url);
      request.fields["Title"] = blogTitle;
      request.fields["Content"] = blogContent;
      request.fields["Author"] = author;

      final file =
          await http.MultipartFile.fromPath("File", selectedImage!.path);
      request.files.add(file);

      final response = await request.send();

      if (response.statusCode == 201) {
        // Başarılı
        Navigator.pop(context);
      }
    }
  }

  void _pickImage() async {
    final imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Blog Ekle"),
        backgroundColor: const Color.fromRGBO(199, 138, 249, 1),
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: const Color.fromRGBO(199, 138, 249, 1),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickImage();
                },
                child: const Text("Fotoğraf Seç"),
              ),
              if (selectedImage != null) Image.file(File(selectedImage!.path)),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Blog Başlığını Giriniz",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (newValue) {
                  blogTitle = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Blog başlığı boş olamaz.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Blog İçeriğini Giriniz",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (newValue) {
                  blogContent = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Blog içeriği boş olamaz.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Yazar İsmini Giriniz",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onSaved: (newValue) {
                  author = newValue!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Yazar ismi boş bırakılmaz";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _submit();
                  }
                },
                child: const Text("Kaydet"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
