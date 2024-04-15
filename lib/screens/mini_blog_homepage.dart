import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniblog/models/mini_blog_model.dart';
import 'package:miniblog/providers/mini_blog_provider.dart';
import 'package:miniblog/screens/mini_blog_addblog.dart';
import 'package:miniblog/screens/mini_blog_content.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 138, 249, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(199, 138, 249, 1),
        title: const Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddBlog()),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final AsyncValue<List<Blog>> blogsAsyncValue =
              ref.watch(blogProvider);
          return blogsAsyncValue.when(
            data: (blogs) {
              return ListView.builder(
                itemCount: blogs.length,
                itemBuilder: (context, index) {
                  final Blog blog = blogs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ContentPage(
                                selectedContentId: blog.id.toString())),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Card(
                        elevation: 4, // Kartı yükseltmek için gölge ekler
                        child: SizedBox(
                          height: 100, // ListTile'in yüksekliğini ayarla
                          child: ListTile(
                            title: Text(
                              blog.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Yazar: ${blog.author}"),
                            leading: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                blog.thumbnail,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}
