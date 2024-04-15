import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniblog/models/mini_blog_model.dart';
import 'package:miniblog/providers/mini_blog_provider.dart';

class ContentPage extends ConsumerStatefulWidget {
  final String selectedContentId;

  const ContentPage({Key? key, required this.selectedContentId})
      : super(key: key);

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends ConsumerState<ContentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(199, 138, 249, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromRGBO(199, 138, 249, 1),
        elevation: 0,
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<List<Blog>> blogsAsyncValue = ref.watch(blogProvider);
        return blogsAsyncValue.when(
          data: (blogs) {
            Blog? selectedBlog;
            try {
              selectedBlog = blogs
                  .firstWhere((blog) => blog.id == widget.selectedContentId);
            } catch (e) {
              // Belirtilen başlığa sahip içerik bulunamadı
              return const Center(
                child: Text('İçerik bulunamadı.'),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 4,
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(selectedBlog.thumbnail),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedBlog.title,
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Divider(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Yazar: ${selectedBlog.author}',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              Text(
                                selectedBlog.content,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text('Hata: $error'),
          ),
        );
      },
    );
  }
}
