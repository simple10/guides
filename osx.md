# Reset Thumbnail Cache

On occasion, OSX will display low -es (blurry) icons in the dock or finder.
This command will reset the icons.

```bash
qlmanage -r cache && sudo find /private/var/folders -name "thumbnails.data" -delete
```

Now restart and the icons should be back to normal high-res.
