${{ content_synopsis }} This image will run the Netbird client as a container. Generating a [setup key](https://docs.netbird.io/how-to/register-machines-using-setup-keys) is all you need to do.

${{ content_uvp }} Good question! Because ...

${{ github:> [!IMPORTANT] }}
${{ github:> }}* ... this image is auto updated to the latest version via CI/CD
${{ github:> }}* ... this image has a health check
${{ github:> }}* ... this image is automatically scanned for CVEs before and after publishing
${{ github:> }}* ... this image is created via a secure and pinned CI/CD process
${{ github:> }}* ... this image is very small

If you value security, simplicity and optimizations to the extreme, then this image might be for you.

${{ content_comparison }}

${{ title_volumes }}
* **${{ json_root }}/etc** - Directory of your client configs

${{ content_compose }}

${{ content_defaults }}

${{ content_environment }}

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}

${{ title_caution }}
${{ github:> [!CAUTION] }}
${{ github:> }}* This image must run as root and will require the wireguard module being loaded in the host’s kernel. If you don’t need a full client but only an exit node or a side car container, use [11notes/ netbird-exit-node](https://github.com/11notes/docker-netbird-exit-node) which is [rootless](https://github.com/11notes/RTFM/blob/main/linux/container/image/rootless.md)