import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:provider/provider.dart';
import '../../providers/book_provider.dart';
import '../../models/book.dart';

class PostBookScreen extends StatefulWidget {
  final Book? editing;
  const PostBookScreen({super.key, this.editing});

  @override
  State<PostBookScreen> createState() => _PostBookScreenState();
}

class _PostBookScreenState extends State<PostBookScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _author = TextEditingController();
  final _swapFor = TextEditingController();
  String _condition = 'New';
  bool _loading = false;
  bool _isUploading = false;
  String _imageBase64 = '';

  @override
  void initState() {
    super.initState();
    final b = widget.editing;
    if (b != null) {
      _title.text = b.title;
      _author.text = b.author;
      _swapFor.text = b.swapFor;
      _condition = b.condition;
      _imageBase64 = b.imageBase64;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      String base64Image;

      if (kIsWeb) {
        // Web: Read directly
        final bytes = await picked.readAsBytes();
        base64Image = base64Encode(bytes);
      } else {
        // Mobile: Compress before encoding
        final file = File(picked.path);
        final compressed = await FlutterImageCompress.compressAndGetFile(
          file.path,
          '${file.path}_compressed.jpg',
          quality: 70,
          minWidth: 800,
          minHeight: 800,
        );
        base64Image = base64Encode(await compressed!.readAsBytes());
      }

      setState(() {
        _imageBase64 = base64Image;
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image upload failed')),
      );
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<BookProvider>();
    final editing = widget.editing;
    return Scaffold(
      appBar: AppBar(title: Text(editing == null ? 'Post a Book' : 'Edit Book')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(controller: _title, validator: _req, decoration: const InputDecoration(labelText: 'Book Title')),
            const SizedBox(height: 12),
            TextFormField(controller: _author, validator: _req, decoration: const InputDecoration(labelText: 'Author')),
            const SizedBox(height: 12),
            TextFormField(controller: _swapFor, decoration: const InputDecoration(labelText: 'Swap For')),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _condition,
              decoration: const InputDecoration(labelText: 'Condition'),
              items: const [
                DropdownMenuItem(value: 'New', child: Text('New')),
                DropdownMenuItem(value: 'Like New', child: Text('Like New')),
                DropdownMenuItem(value: 'Good', child: Text('Good')),
                DropdownMenuItem(value: 'Used', child: Text('Used')),
              ],
              onChanged: (v) => setState(() => _condition = v!),
            ),
            const SizedBox(height: 16),
            // Image picker
            GestureDetector(
              onTap: _isUploading ? null : _pickImage,
              child: Container(
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : _imageBase64.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.memory(
                              base64Decode(_imageBase64),
                              height: 160,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate, size: 48, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Tap to add cover image', style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : () async {
                if (!_form.currentState!.validate()) return;
                setState(() => _loading = true);
                try {
                  if (editing == null) {
                    await prov.create(
                      title: _title.text.trim(),
                      author: _author.text.trim(),
                      condition: _condition,
                      swapFor: _swapFor.text.trim(),
                      imageBase64: _imageBase64,
                    );
                  } else {
                    await prov.update(
                      id: editing.id,
                      title: _title.text.trim(),
                      author: _author.text.trim(),
                      condition: _condition,
                      swapFor: _swapFor.text.trim(),
                      imageBase64: _imageBase64,
                    );
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Book ${editing == null ? 'posted' : 'updated'} successfully!')),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
              child: _loading 
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Saving...'),
                      ],
                    )
                  : Text(editing == null ? 'Post' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  String? _req(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;
}