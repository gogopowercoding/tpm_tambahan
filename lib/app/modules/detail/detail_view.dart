import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'detail_controller.dart';

class DetailView extends GetView<DetailController> {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Terjadi kesalahan:\n${controller.errorMessage.value}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchDetail,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final article = controller.article.value;
        if (article == null) return const SizedBox();

        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Image
                  article.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: article.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 250,
                            color: Colors.grey[200],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 250,
                            color: Colors.grey[100],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    size: 50, color: Colors.grey[400]),
                                const SizedBox(height: 8),
                                Text('Gambar tidak tersedia',
                                    style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 250,
                          color: Colors.grey[100],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image_not_supported,
                                  size: 50, color: Colors.grey[400]),
                              const SizedBox(height: 8),
                              Text('Gambar tidak tersedia',
                                  style: TextStyle(
                                      color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                        ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // News Site
                        Row(
                          children: [
                            const Icon(Icons.language,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              article.newsSite,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Date
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              controller.formatDate(article.publishedAt),
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 12),

                        // Summary
                        const Text(
                          'Ringkasan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.summary.isNotEmpty
                              ? article.summary
                              : 'Tidak ada ringkasan tersedia.',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),

                        // ============ LBS CARD ============
                        const Text(
                          '📍 Lokasi Anda Saat Ini',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0EEFF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFF6C63FF)
                                        .withOpacity(0.3)),
                              ),
                              child: controller.isLoadingLocation.value
                                  ? const Row(
                                      children: [
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                        SizedBox(width: 12),
                                        Text('Mengambil lokasi...'),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.location_on,
                                                color: Color(0xFF6C63FF),
                                                size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                controller.currentLocation.value
                                                        .isNotEmpty
                                                    ? controller
                                                        .currentLocation.value
                                                    : 'Lokasi tidak tersedia',
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (controller.latitude.value != 0.0)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 6),
                                            child: Text(
                                              'Lat: ${controller.latitude.value.toStringAsFixed(5)}, '
                                              'Lng: ${controller.longitude.value.toStringAsFixed(5)}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: OutlinedButton.icon(
                                            onPressed: controller.getLocation,
                                            icon: const Icon(Icons.refresh,
                                                size: 16),
                                            label:
                                                const Text('Perbarui Lokasi'),
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor:
                                                  const Color(0xFF6C63FF),
                                              side: const BorderSide(
                                                  color: Color(0xFF6C63FF)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            )),

                        // Extra space for FAB
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating Action Button
            Positioned(
              bottom: 24,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: controller.launchArticleUrl,
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Baca Selengkapnya'),
              ),
            ),
          ],
        );
      }),
    );
  }
}
