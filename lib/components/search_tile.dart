import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:go_router/go_router.dart';
import 'package:gyavun/api/extensions.dart';
import 'package:gyavun/providers/media_manager.dart';
import 'package:gyavun/ui/text_styles.dart';
import 'package:gyavun/utils/downlod.dart';
import 'package:gyavun/utils/option_menu.dart';
import 'package:provider/provider.dart';

class SearchTile extends StatelessWidget {
  final Map item;
  const SearchTile({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (item['type'] == 'song' || item['type'] == 'video') {
          context.read<MediaManager>().addAndPlay([item]);
        } else if (item['type'] == 'artist') {
          context.go('/search/artist', extra: item);
        } else {
          context.go('/search/list', extra: item);
        }
      },
      onLongPress: () {
        if (item['type'] == 'song' || item['type'] == 'video') {
          showSongOptions(context, Map.from(item));
        }
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(
              item['type'].toString().capitalize() == 'Artist' ||
                      item['type'].toString().capitalize() == 'Profile'
                  ? 30
                  : 8),
          child: CachedNetworkImage(imageUrl: item['image'], height: 50)),
      title: Text(
        item['title'],
        style: subtitleTextStyle(context, bold: true),
        maxLines: 1,
      ),
      subtitle: Text(
        item['subtitle'],
        style: smallTextStyle(context),
        maxLines: 1,
      ),
    );
  }
}

class DownloadTile extends StatelessWidget {
  const DownloadTile({
    super.key,
    required this.index,
    required this.items,
    required this.image,
  });

  final int index;
  final List<Map> items;
  final Uri image;

  @override
  Widget build(BuildContext context) {
    Map song = items[index];

    return SwipeActionCell(
        key: Key(index.toString()),
        trailingActions: [
          SwipeAction(
              onTap: (CompletionHandler handler) async {
                await handler(true);
                await deleteSong(key: song['id'], path: song['path']);
              },
              title: "Delete")
        ],
        child: ListTile(
          onTap: () {
            context.read<MediaManager>().addAndPlay(
                items.map((e) => {'id': e['id']}).toList(),
                initialIndex: index,
                autoFetch: false);
          },
          onLongPress: () async => showSongOptions(context, {
            'id': song['id'],
            'title': song['title'],
            'artist': song['artist'],
            'album': song['album'],
            'url': song['path'],
            'image': image.path,
            'offline': true,
          }),
          title: Text(
            song['title'],
            style: subtitleTextStyle(context, bold: true),
            maxLines: 1,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File.fromUri(image),
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(song['image']);
              },
            ),
          ),
          subtitle: Text(
            song['artist'],
            style: smallTextStyle(context),
            maxLines: 1,
          ),
        ));
  }
}
