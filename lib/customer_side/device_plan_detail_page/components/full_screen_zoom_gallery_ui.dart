import 'package:flutter/material.dart';

class FullScreenZoomGalleryUi extends StatefulWidget {
  final int initialIndex;
  final List<String> images;

  const FullScreenZoomGalleryUi({
    super.key,
    required this.initialIndex,
    required this.images,
  });

  static void show(BuildContext context, int initialIndex, List<String> images) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.95),
      builder: (_) => FullScreenZoomGalleryUi(
        initialIndex: initialIndex,
        images: images,
      ),
    );
  }

  @override
  State<FullScreenZoomGalleryUi> createState() => _FullScreenZoomGalleryUiState();
}

class _FullScreenZoomGalleryUiState extends State<FullScreenZoomGalleryUi> {
  late int curIdx;
  late final PageController pageController;
  final TransformationController _transformController = TransformationController();
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    curIdx = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
    _transformController.addListener(() {
      final double scale = _transformController.value.getMaxScaleOnAxis();
      if (scale > 1.05 && !_isZoomed) {
        setState(() => _isZoomed = true);
      } else if (scale <= 1.05 && _isZoomed) {
        setState(() => _isZoomed = false);
      }
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'تصویر ${curIdx + 1} از ${widget.images.length}',
          style: const TextStyle(fontSize: 13, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: pageController,
              physics: _isZoomed ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
              itemCount: widget.images.length,
              onPageChanged: (idx) {
                _transformController.value = Matrix4.identity();
                setState(() => curIdx = idx);
              },
              itemBuilder: (context, i) {
                return InteractiveViewer(
                  transformationController: _transformController,
                  panEnabled: _isZoomed,
                  minScale: 1.0,
                  maxScale: 3.5,
                  child: Center(
                    child: Image.network(
                      widget.images[i],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (widget.images.length > 1)
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (i) {
                  final bool isSel = curIdx == i;
                  return GestureDetector(
                    onTap: () {
                      _transformController.value = Matrix4.identity();
                      pageController.animateToPage(
                        i,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSel ? const Color(0xFF34D399) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(widget.images[i], fit: BoxFit.cover),
                      ),
                    ),
                  );
                }),
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}