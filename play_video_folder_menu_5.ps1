﻿cls

<#
je adresar "C:\Users\DELL\Videos\" vnem jsou videa ruzny tipy pripon avi, mp4, mpg
v adresar "C:\Users\DELL\Videos\" jsou dalsi adresare a nem zase videa napr. "C:\Users\DELL\Videos\neco\"
muzou bejt i dalsi vnoreny podadresare napr. "C:\Users\DELL\Videos\neco_1\neco_2\"
vytvori menu a z ADRESARU ktery najde v ceste "C:\Users\DELL\Videos\" videa primo v teto slozce jsou pod volbou "0" v menu
adresare nacita rekurzivne, samozderjme mimo volby nula
je protreba nainstlovat program "mvp" pro windows viz. radek 66
pri kompilaci do exe souboru trochu blbne vystup viz. screenshot, takze radeji nechat takto jako script a poustet
treba prikazem "powershell -File video_menu_ps1" z davkoviho souboru apod.
upne do dlouhej vypis napovedy pro mpv, vsechny mozny paorametry, rychlost prehravani vide, mute atd. atd. - Total: 1110 options
takze hrat si z radem 114

asi lepsi zpusob nez vytvaret nejaky playlisty, ti pak muset aktualizovat, takle proste prehraje co je aktualne v adresari
bez nakyho dalsiho srani z necim
z malou modifikaci prehrava i soubory wav, mp3, flac atd. v adresari "C:\Users\DELL\Music\"
upravit radek 32 a 92 
priklad : $pripony = @("*.mp3", "*.wav", "*.ogg", "*.flac")
na obrazku mpv_keyboard_control.jpg neuveritelne bohaty ovladani programu mpv pomoci klavesnice
napr. klavesa mezernik pause/unpause videa, klavesa "f" pro ciklovani mezi fullscreen nebo prehravani videa v okne 
klavesa "m" mute/unmute a dalsi a dasli
#>

[string] $scriptName = pwd
$scriptName += $MyInvocation.MyCommand.Name
$host.UI.RawUI.WindowTitle = $scriptName

Remove-Variable vybran_adresar, d_adresare, adresare, aa, d_files, file, files -ErrorAction SilentlyContinue

##################################################################################
$cesta_folder_videos = "C:\Users\DELL\Videos\" #  <<<<<<<   tady menit podle sebe
##################################################################################

if (-not ( Test-Path $cesta_folder_videos )){
Write-Warning "nenalezena cesta : $cesta_folder_videos"
sleep 3
Exit 1
}

$poc = 1
$adresare = @($cesta_folder_videos) # klic 0 bude prazdny
$out_1 = " 0) "
$out_1 += $adresare[0]
echo $out_1

$adresare +=  Get-ChildItem -Attributes Directory -Path $cesta_folder_videos -Name | Sort-Object
$d_adresare = $adresare.Length -1
#echo $d_adresare

for ( $aa = 1; $aa -le $d_adresare; $aa++ ) {
$out_2 = " "
$out_2 += $poc
$out_2 += ") "
$out_2 += $cesta_folder_videos
$out_2 += $adresare[$aa]
$out_2 += "\"
echo $out_2
$poc++
}

[int32] $vybran_adresar = Read-Host -Prompt "zadej 0 az $d_adresare"

if ( $vybran_adresar -lt 0 -or $vybran_adresar -gt $d_adresare ) {
Write-Warning "chyba zadani"
sleep 3
Exit 1
}


$soubory = $cesta_folder_videos

if ( $vybran_adresar -ne 0 ) {
$soubory += $adresare[$vybran_adresar]
$soubory += "\"
}


$mpv = ("C:\Program Files (x86)\mpv-x86_64\mpv") # << toto menit podle sebe ( nechat com )
# pozor je tam soubor mpv.com a mpv.exe
# kdyz je $mpv = ("C:\Program Files (x86)\mpv-x86_64\mpv.exe") tak pousi videa ne za sebou ale vsechny na jednou treba 80 videji !  
if (-not (Test-Path $mpv)){
Write-Warning "nenalezen soubor $mpv"
sleep 3
exit
}

$files=@() #  < toto tady musi byt jinak pri jednom souboru v adresari dela $files.GetType() = String a pri nule a nebo
# vice nez jednom souboru zase dala $files.GetType() = Array ( cili mu rict ze vzdycky a je tip Array)
# promenna $d_files pak misto poctu prvku pole ukazuje delku retezce strings jako pocet videi v adresari
# docela dlouho jsem hledal proc je chyba kdy to psalo kraviny
$pripony = @("*.mp4", "*.avi", "*.mpg") # pripovny videa toto lze menit podle sebe viz na zacatku prehavani hudby
# v ceste $cesta_folder_videos nacita soubory z vybraneho adresare
if ( $vybran_adresar -ne 0 ) {
$files += Get-ChildItem -path $soubory -include $pripony -recurse -name  | Sort-Object # pridej do prazdnyho pole ( typ Array)
}else{
$files += Get-ChildItem -path $soubory -include $pripony -Name  | Sort-Object
# jenom soubory z pole $propony a bez adresaru ^^^
}

$d_files = $files.Length
$out_3 = 'pocet videi v adresari "'
$out_3 += $soubory
$out_3 += '" = '
$out_3 += $d_files
echo $out_3
sleep 1


foreach($file in $files){
echo $soubory$file
sleep 2
#& $mpv "-fs" "$soubory$file" # pise to sice nejakou chybu ale funguje to
& $mpv "-fs" "--osd-level=3" "--osd-font-size=20" "$soubory$file"
# ^^^ spusti v cmd.exe prikaz napr.
# C:\Program Files (x86)\mpv-x86_64\mpv.com -fs --osd-level=3 --osd-font-size=20 C:\Users\DELL\Videos\nejakej_adresar\video_cislo_1.avi
sleep 1
}


<# mvp --help dalsi mozny nastaveni pro mpv -mute apod.

 --3dlut-size                     alias [deprecated] for icc-3dlut-size
 --a52drc                         removed [deprecated]
 --ab-loop-a                      Time (default: no)
 --ab-loop-b                      Time (default: no)
 --ab-loop-count                  Choices: inf (or an integer) (0 to 2147483647) (default: inf)
 --access-references              Flag (default: yes)
 --ad                             String (default: )
 --ad-lavc-ac3drc                 Float (0 to 6) (default: 0.000)
 --ad-lavc-downmix                Flag (default: no)
 --ad-lavc-o                      Key/value list (default: )
    --ad-lavc-o-add
    --ad-lavc-o-append
    --ad-lavc-o-set
    --ad-lavc-o-remove
 --ad-lavc-threads                Integer (0 to 16) (default: 1)
 --ad-queue-enable                Flag (default: no)
 --ad-queue-max-bytes             ByteSize (0 to 4.6116860184274e+18) (default: 1.000 MiB)
 --ad-queue-max-samples           Integer64 (0 to any) (default: 48000)
 --ad-queue-max-secs              Double (0 to any) (default: 1.000)
 --af                             Object settings list (default: )
    --af-add
    --af-append
    --af-clr
    --af-del
    --af-help
    --af-pre
    --af-set
    --af-toggle
    --af-remove
 --af-defaults                    Object settings list (default: ) [deprecated]
    --af-defaults-add
    --af-defaults-append
    --af-defaults-clr
    --af-defaults-del
    --af-defaults-help
    --af-defaults-pre
    --af-defaults-set
    --af-defaults-toggle
    --af-defaults-remove
 --afm                            removed [deprecated]
 --aid                            Choices: no auto (or an integer) (0 to 8190) (default: auto)
 --alang                          String list (default: )
    --alang-add
    --alang-append
    --alang-clr
    --alang-del
    --alang-pre
    --alang-set
    --alang-toggle
    --alang-remove
 --allow-delayed-peak-detect      Flag (default: yes)
 --alpha                          Choices: no yes blend blend-tiles (default: blend-tiles)
 --angle-d3d11-feature-level      Choices: 11_0 10_1 10_0 9_3 (default: 11_0)
 --angle-d3d11-warp               Choices: auto no yes (default: auto)
 --angle-egl-windowing            Choices: auto no yes (default: auto)
 --angle-flip                     Flag (default: yes)
 --angle-max-frame-latency        alias [deprecated] for swapchain-depth
 --angle-renderer                 Choices: auto d3d9 d3d11 (default: auto)
 --angle-swapchain-length         removed [deprecated]
 --ao                             Object settings list (default: )
    --ao-add
    --ao-append
    --ao-clr
    --ao-del
    --ao-help
    --ao-pre
    --ao-set
    --ao-toggle
    --ao-remove
 --ao-null-broken-delay           Flag (default: no)
 --ao-null-broken-eof             Flag (default: no)
 --ao-null-buffer                 Float (0 to 100) (default: 0.200)
 --ao-null-channel-layouts        Audio channels or channel map (default: )
 --ao-null-format                 Audio format (default: no)
 --ao-null-latency                Float (0 to 100) (default: 0.000)
 --ao-null-outburst               Integer (1 to 100000) (default: 256)
 --ao-null-speed                  Float (0 to 10000) (default: 1.000)
 --ao-null-untimed                Flag (default: no)
 --ao-pcm-append                  Flag (default: no)
 --ao-pcm-file                    String (default: ) [file]
 --ao-pcm-waveheader              Flag (default: yes)
 --aspect                         alias [deprecated] for video-aspect-override
 --ass                            alias [deprecated] for sub-ass
 --ass-bottom-margin              removed [deprecated]
 --ass-force-margins              alias [deprecated] for sub-ass-force-margins
 --ass-force-style                alias [deprecated] for sub-ass-force-style
 --ass-hinting                    alias [deprecated] for sub-ass-hinting
 --ass-line-spacing               alias [deprecated] for sub-ass-line-spacing
 --ass-scale-with-window          alias [deprecated] for sub-ass-scale-with-window
 --ass-shaper                     alias [deprecated] for sub-ass-shaper
 --ass-style-override             alias [deprecated] for sub-ass-style-override
 --ass-styles                     alias [deprecated] for sub-ass-styles
 --ass-use-margins                alias [deprecated] for sub-use-margins
 --ass-vsfilter-aspect-compat     alias [deprecated] for sub-ass-vsfilter-aspect-compat
 --ass-vsfilter-blur-compat       alias [deprecated] for sub-ass-vsfilter-blur-compat
 --ass-vsfilter-color-compat      alias [deprecated] for sub-ass-vsfilter-color-compat
 --audio                          alias for aid
 --audio-backward-batch           Integer (0 to 1024) (default: 10)
 --audio-backward-overlap         Choices: auto (or an integer) (0 to 1024) (default: auto)
 --audio-buffer                   Double (0 to 10) (default: 0.200)
 --audio-channels                 Audio channels or channel map (default: auto-safe)
 --audio-client-name              String (default: mpv)
 --audio-delay                    Float (default: 0.000)
 --audio-demuxer                  String (default: )
 --audio-device                   String (default: auto)
 --audio-display                  Choices: no embedded-first external-first (default: embedded-first)
 --audio-exclusive                Flag (default: no)
 --audio-fallback-to-null         Flag (default: no)
 --audio-file                     alias for --audio-files-append (CLI/config files only)
 --audio-file-auto                Choices: no exact fuzzy all (default: no)
 --audio-file-paths               String list (default: ) [file]
    --audio-file-paths-add
    --audio-file-paths-append
    --audio-file-paths-clr
    --audio-file-paths-del
    --audio-file-paths-pre
    --audio-file-paths-set
    --audio-file-paths-toggle
    --audio-file-paths-remove
 --audio-files                    String list (default: ) [file]
    --audio-files-add
    --audio-files-append
    --audio-files-clr
    --audio-files-del
    --audio-files-pre
    --audio-files-set
    --audio-files-toggle
    --audio-files-remove
 --audio-format                   Audio format (default: no)
 --audio-normalize-downmix        Flag (default: no)
 --audio-pitch-correction         Flag (default: yes)
 --audio-resample-cutoff          Double (0 to 1) (default: 0.000)
 --audio-resample-filter-size     Integer (0 to 32) (default: 16)
 --audio-resample-linear          Flag (default: no)
 --audio-resample-max-output-size Double (default: 40.000)
 --audio-resample-phase-shift     Integer (0 to 30) (default: 10)
 --audio-reversal-buffer          ByteSize (0 to 4.6116860184274e+18) (default: 64.000 MiB)
 --audio-samplerate               Integer (0 to 768000) (default: 0)
 --audio-spdif                    String (default: )
 --audio-stream-silence           Flag (default: no)
 --audio-swresample-o             Key/value list (default: )
    --audio-swresample-o-add
    --audio-swresample-o-append
    --audio-swresample-o-set
    --audio-swresample-o-remove
 --audio-wait-open                Float (0 to 60) (default: 0.000)
 --audiofile                      alias [deprecated] for audio-file
 --autofit                        Window size (default: )
 --autofit-larger                 Window size (default: )
 --autofit-smaller                Window size (default: )
 --autoload-files                 Flag (default: yes)
 --autosub                        alias [deprecated] for sub-auto
 --autosub-match                  alias [deprecated] for sub-auto
 --autosync                       Choices: no (or an integer) (0 to 10000) (default: 0)
 --background                     Color (default: #FF000000)
 --benchmark                      removed [deprecated]
 --blend-subtitles                Choices: no yes video (default: no)
 --bluray-angle                   removed [deprecated]
 --bluray-device                  String (default: ) [file]
 --border                         Flag (default: yes)
 --brightness                     Integer (-100 to 100) (default: 0)
 --cache                          Choices: no auto yes (default: auto)
 --cache-dir                      String (default: ) [file]
 --cache-on-disk                  Flag (default: no)
 --cache-pause                    Flag (default: yes)
 --cache-pause-below              removed [deprecated]
 --cache-pause-initial            Flag (default: no)
 --cache-pause-wait               Float (0 to any) (default: 1.000)
 --cache-secs                     Double (0 to any) (default: 3600000.000)
 --cache-unlink-files             Choices: immediate whendone no (default: immediate)
 --capture                        removed [deprecated]
 --channels                       removed [deprecated]
 --chapter                        removed [deprecated]
 --chapter-merge-threshold        Integer (0 to 10000) (default: 100)
 --chapter-seek-threshold         Double (default: 5.000)
 --chapters-file                  String (default: ) [file]
 --config                         Flag (default: yes)
 --config-dir                     String (default: ) [not in config files] [file]
 --contrast                       Integer (-100 to 100) (default: 0)
 --cookies                        Flag (default: no)
 --cookies-file                   String (default: ) [file]
 --correct-downscaling            Flag (default: no)
 --correct-pts                    Flag (default: yes)
 --cover-art-auto                 Choices: no exact fuzzy all (default: exact)
 --cover-art-file                 alias for --cover-art-files-append (CLI/config files only)
 --cover-art-files                String list (default: ) [file]
    --cover-art-files-add
    --cover-art-files-append
    --cover-art-files-clr
    --cover-art-files-del
    --cover-art-files-pre
    --cover-art-files-set
    --cover-art-files-toggle
    --cover-art-files-remove
 --cover-art-whitelist            Flag (default: yes)
 --cscale                         String (default: bilinear)
 --cscale-antiring                Float (0 to 1) (default: 0.000)
 --cscale-blur                    Float (default: 0.000)
 --cscale-clamp                   Float (0 to 1) (default: 0.000)
 --cscale-cutoff                  Float (0 to 1) (default: 0.001)
 --cscale-param1                  Float (default: default)
 --cscale-param2                  Float (default: default)
 --cscale-radius                  Float (0.5 to 16) (default: 0.000)
 --cscale-taper                   Float (0 to 1) (default: 0.000)
 --cscale-wblur                   Float (default: 0.000)
 --cscale-window                  String (default: )
 --cscale-wparam                  Float (default: default)
 --cscale-wtaper                  Float (0 to 1) (default: 0.000)
 --cuda-decode-device             Choices: auto (or an integer) (0 to 2147483647) (default: auto)
 --cursor-autohide                Choices: no always (or an integer) (0 to 30000) (default: 1000)
 --cursor-autohide-delay          alias [deprecated] for cursor-autohide
 --cursor-autohide-fs-only        Flag (default: no)
 --d3d11-adapter                  String (default: )
 --d3d11-exclusive-fs             Flag (default: no)
 --d3d11-feature-level            Choices: 12_1 12_0 11_1 11_0 10_1 10_0 9_3 9_2 9_1 (default: 12_1)
 --d3d11-flip                     Flag (default: yes)
 --d3d11-output-csp               Choices: auto srgb linear pq bt.2020 (default: auto)
 --d3d11-output-format            Choices: auto rgba8 bgra8 rgb10_a2 rgba16f (default: auto)
 --d3d11-sync-interval            Integer (0 to 4) (default: 1)
 --d3d11-warp                     Choices: auto no yes (default: auto)
 --d3d11va-zero-copy              Flag (default: no)
 --deband                         Flag (default: no)
 --deband-grain                   Float (0 to 4096) (default: 48.000)
 --deband-iterations              Integer (1 to 16) (default: 1)
 --deband-range                   Float (1 to 64) (default: 16.000)
 --deband-threshold               Float (0 to 4096) (default: 32.000)
 --deinterlace                    Flag (default: no)
 --delay                          alias [deprecated] for audio-delay
 --demuxer                        String (default: )
 --demuxer-backward-playback-step Double (0 to any) (default: 60.000)
 --demuxer-cache-wait             Flag (default: no)
 --demuxer-cue-codepage           String (default: auto)
 --demuxer-donate-buffer          Flag (default: yes)
 --demuxer-force-retry-on-eof     Flag (default: no) [deprecated]
 --demuxer-lavf-allow-mimetype    Flag (default: yes)
 --demuxer-lavf-analyzeduration   Float (0 to 3600) (default: 0.000)
 --demuxer-lavf-buffersize        Integer (1 to 10485760) (default: 32768)
 --demuxer-lavf-format            String (default: )
 --demuxer-lavf-hacks             Flag (default: yes)
 --demuxer-lavf-linearize-timestamps Choices: no auto yes (default: auto)
 --demuxer-lavf-o                 Key/value list (default: )
    --demuxer-lavf-o-add
    --demuxer-lavf-o-append
    --demuxer-lavf-o-set
    --demuxer-lavf-o-remove
 --demuxer-lavf-probe-info        Choices: no yes auto nostreams (default: auto)
 --demuxer-lavf-probescore        Integer (1 to 100) (default: 26)
 --demuxer-lavf-probesize         Integer (32 to 2147483647) (default: 0)
 --demuxer-lavf-propagate-opts    Flag (default: yes)
 --demuxer-max-back-bytes         ByteSize (0 to 4.6116860184274e+18) (default: 50.000 MiB)
 --demuxer-max-bytes              ByteSize (0 to 4.6116860184274e+18) (default: 150.000 MiB)
 --demuxer-mkv-probe-start-time   Flag (default: yes)
 --demuxer-mkv-probe-video-duration Choices: no yes full (default: no)
 --demuxer-mkv-subtitle-preroll   Choices: no yes index (default: index)
 --demuxer-mkv-subtitle-preroll-secs Double (0 to any) (default: 1.000)
 --demuxer-mkv-subtitle-preroll-secs-index Double (0 to any) (default: 10.000)
 --demuxer-rawaudio-channels      Audio channels or channel map (default: stereo)
 --demuxer-rawaudio-format        Choices: u8 s8 u16le u16be s16le s16be u24le u24be s24le s24be u32le u32be s32le s32be floatle floatbe doublele doublebe u16 s16 u24 s24 u32 s32 float double (default: s16le)
 --demuxer-rawaudio-rate          Integer (1000 to 384000) (default: 44100)
 --demuxer-rawvideo-codec         String (default: )
 --demuxer-rawvideo-format        FourCC (default: 30323449)
 --demuxer-rawvideo-fps           Float (0.001 to 1000) (default: 25.000)
 --demuxer-rawvideo-h             Integer (1 to 8192) (default: 720)
 --demuxer-rawvideo-mp-format     Image format (default: no)
 --demuxer-rawvideo-size          Integer (1 to 268435456) (default: 0)
 --demuxer-rawvideo-w             Integer (1 to 8192) (default: 1280)
 --demuxer-readahead-secs         Double (0 to any) (default: 1.000)
 --demuxer-seekable-cache         Choices: auto no yes (default: auto)
 --demuxer-termination-timeout    Double (default: 0.100)
 --demuxer-thread                 Flag (default: yes)
 --display-fps                    alias [deprecated] for override-display-fps
 --display-tags                   String list (default: Artist,Album,Album_Artist,Comment,Composer,Date,Description,Genre,Performer,Rating,Series,Title,Track,icy-title,service_name,Uploader,Channel_URL)
    --display-tags-add
    --display-tags-append
    --display-tags-clr
    --display-tags-del
    --display-tags-pre
    --display-tags-set
    --display-tags-toggle
    --display-tags-remove
 --dither                         Choices: fruit ordered error-diffusion no (default: fruit)
 --dither-depth                   Choices: no auto (or an integer) (-1 to 16) (default: no)
 --dither-size-fruit              Integer (2 to 8) (default: 6)
 --dscale                         String (default: )
 --dscale-antiring                Float (0 to 1) (default: 0.000)
 --dscale-blur                    Float (default: 0.000)
 --dscale-clamp                   Float (0 to 1) (default: 0.000)
 --dscale-cutoff                  Float (0 to 1) (default: 0.001)
 --dscale-param1                  Float (default: default)
 --dscale-param2                  Float (default: default)
 --dscale-radius                  Float (0.5 to 16) (default: 0.000)
 --dscale-taper                   Float (0 to 1) (default: 0.000)
 --dscale-wblur                   Float (default: 0.000)
 --dscale-window                  String (default: )
 --dscale-wparam                  Float (default: default)
 --dscale-wtaper                  Float (0 to 1) (default: 0.000)
 --dump-stats                     String (default: ) [file]
 --dumpstream                     removed [deprecated]
 --dvd-angle                      Integer (1 to 99) (default: 1)
 --dvd-device                     String (default: ) [file]
 --dvd-speed                      Integer (default: 0)
 --dvdangle                       alias [deprecated] for dvd-angle
 --edition                        Choices: auto (or an integer) (0 to 8190) (default: auto)
 --embeddedfonts                  Flag (default: yes)
 --end                            Relative time or percent position (default: none)
 --endpos                         alias [deprecated] for length
 --error-diffusion                String (default: sierra-lite)
 --external-file                  alias for --external-files-append (CLI/config files only)
 --external-files                 String list (default: ) [file]
    --external-files-add
    --external-files-append
    --external-files-clr
    --external-files-del
    --external-files-pre
    --external-files-set
    --external-files-toggle
    --external-files-remove
 --fbo-format                     String (default: auto)
 --fit-border                     Flag (default: yes) [deprecated]
 --fixed-vo                       removed [deprecated]
 --focus-on-open                  Flag (default: yes)
 --font                           alias [deprecated] for osd-font
 --force-media-title              String (default: )
 --force-rgba-osd-rendering       Flag (default: no)
 --force-seekable                 Flag (default: no)
 --force-window                   Choices: no yes immediate (default: no)
 --force-window-position          Flag (default: no)
 --forcedsubsonly                 alias [deprecated] for sub-forced-only
 --forceidx                       alias [deprecated] for index
 --format                         alias [deprecated] for audio-format
 --fps                            Double (0 to any) (default: 0.000)
 --framedrop                      Choices: no vo decoder decoder+vo (default: vo)
 --frames                         Choices: all (or an integer) (0 to 2147483647) (default: all)
 --fs                             alias for fullscreen
 --fs-black-out-screens           removed [deprecated]
 --fs-screen                      Choices: all current (or an integer) (0 to 32) (default: current)
 --fs-screen-name                 String (default: )
 --fullscreen                     Flag (default: no)
 --gamma                          Integer (-100 to 100) (default: 0)
 --gamma-auto                     Flag (default: no)
 --gamma-factor                   Float (0.1 to 2) (default: 1.000)
 --gamut-clipping                 removed [deprecated]
 --gamut-mapping-mode             Choices: auto clip warn desaturate darken (default: auto)
 --gamut-warning                  removed [deprecated]
 --gapless-audio                  Choices: no yes weak (default: weak)
 --geometry                       Window geometry (default: )
 --glsl-shader                    alias for --glsl-shaders-append (CLI/config files only)
 --glsl-shaders                   String list (default: ) [file]
    --glsl-shaders-add
    --glsl-shaders-append
    --glsl-shaders-clr
    --glsl-shaders-del
    --glsl-shaders-pre
    --glsl-shaders-set
    --glsl-shaders-toggle
    --glsl-shaders-remove
 --gpu-api                        String (default: )
 --gpu-context                    String (default: )
 --gpu-debug                      Flag (default: no)
 --gpu-dumb-mode                  Choices: auto yes no (default: auto)
 --gpu-hwdec-interop              String (default: auto)
 --gpu-shader-cache-dir           String (default: ) [file]
 --gpu-sw                         Flag (default: no)
 --gpu-tex-pad-x                  Integer (0 to 4096) (default: 0)
 --gpu-tex-pad-y                  Integer (0 to 4096) (default: 0)
 --h                              String (default: ) [not in config files]
 --hardframedrop                  removed [deprecated]
 --hdr-compute-peak               Choices: auto yes no (default: auto)
 --hdr-peak-decay-rate            Float (1 to 1000) (default: 100.000)
 --hdr-scene-threshold-high       Float (0 to 20) (default: 10.000)
 --hdr-scene-threshold-low        Float (0 to 20) (default: 5.500)
 --hdr-tone-mapping               alias [deprecated] for tone-mapping
 --heartbeat-cmd                  removed [deprecated]
 --help                           String (default: ) [not in config files]
 --hidpi-window-scale             Flag (default: yes)
 --hls-bitrate                    Choices: no min max (or an integer) (0 to 2147483647) (default: max)
 --hr-seek                        Choices: no absolute yes always default (default: default)
 --hr-seek-demuxer-offset         Float (default: 0.000)
 --hr-seek-framedrop              Flag (default: yes)
 --http-header-fields             String list (default: )
    --http-header-fields-add
    --http-header-fields-append
    --http-header-fields-clr
    --http-header-fields-del
    --http-header-fields-pre
    --http-header-fields-set
    --http-header-fields-toggle
    --http-header-fields-remove
 --http-proxy                     String (default: )
 --hue                            Integer (-100 to 100) (default: 0)
 --hwdec                          String (default: no)
 --hwdec-codecs                   String (default: h264,vc1,hevc,vp8,vp9,av1,prores)
 --hwdec-extra-frames             Integer (0 to 256) (default: 6)
 --hwdec-image-format             Image format (default: no)
 --hwdec-preload                  alias [deprecated] for opengl-hwdec-interop
 --icc-3dlut-size                 String (default: 64x64x64)
 --icc-cache                      removed [deprecated]
 --icc-cache-dir                  String (default: ) [file]
 --icc-contrast                   removed [deprecated]
 --icc-force-contrast             Choices: no inf (or an integer) (0 to 1000000) (default: no)
 --icc-intent                     Integer (default: 1)
 --icc-profile                    String (default: ) [file]
 --icc-profile-auto               Flag (default: no)
 --identify                       removed [deprecated]
 --idle                           Choices: no once yes (default: no)
 --idx                            alias [deprecated] for index
 --ignore-path-in-watch-later-config Flag (default: no)
 --image-display-duration         Double (0 to inf) (default: 1.000)
 --image-lut                      String (default: ) [file]
 --image-lut-type                 Choices: auto native normalized conversion (default: auto)
 --image-subs-video-resolution    Flag (default: no)
 --include                        String (default: ) [file]
 --index                          Choices: default recreate (default: default)
 --initial-audio-sync             Flag (default: yes)
 --input-ar-delay                 Integer (default: 200)
 --input-ar-rate                  Integer (default: 40)
 --input-builtin-bindings         Flag (default: yes)
 --input-cmdlist                  Print [not in config files]
 --input-conf                     String (default: ) [file]
 --input-cursor                   Flag (default: yes)
 --input-default-bindings         Flag (default: yes)
 --input-doubleclick-time         Integer (0 to 1000) (default: 300)
 --input-gamepad                  Flag (default: no)
 --input-ipc-server               String (default: ) [file]
 --input-key-fifo-size            Integer (2 to 65000) (default: 7)
 --input-keylist                  Print [not in config files]
 --input-media-keys               Flag (default: yes)
 --input-right-alt-gr             Flag (default: yes)
 --input-terminal                 Flag (default: yes)
 --input-test                     Flag (default: no)
 --input-unix-socket              alias [deprecated] for input-ipc-server
 --input-vo-keyboard              Flag (default: yes)
 --input-x11-keyboard             alias [deprecated] for input-vo-keyboard
 --interpolation                  Flag (default: no)
 --interpolation-preserve         Flag (default: yes)
 --interpolation-threshold        Float (default: 0.010)
 --inverse-tone-mapping           Flag (default: no)
 --keep-open                      Choices: no yes always (default: no)
 --keep-open-pause                Flag (default: yes)
 --keepaspect                     Flag (default: yes)
 --keepaspect-window              Flag (default: yes)
 --lavdopts                       removed [deprecated]
 --lavfdopts                      removed [deprecated]
 --lavfi-complex                  String (default: )
 --length                         Relative time or percent position (default: none)
 --linear-downscaling             Flag (default: no)
 --linear-scaling                 removed [deprecated]
 --linear-upscaling               Flag (default: no)
 --list-options                   Flag [not in config files]
 --list-properties                Flag (default: no) [not in config files]
 --list-protocols                 Print [not in config files]
 --load-auto-profiles             Choices: no yes auto (default: auto)
 --load-osd-console               Flag (default: yes)
 --load-scripts                   Flag (default: yes)
 --load-stats-overlay             Flag (default: yes)
 --load-unsafe-playlists          Flag (default: no)
 --log-file                       String (default: ) [file]
 --loop                           alias for loop-file
 --loop-file                      Choices: no inf yes (or an integer) (0 to 10000) (default: no)
 --loop-playlist                  Choices: no inf yes force (or an integer) (1 to 10000) (default: no)
 --lua                            alias [deprecated] for script
 --lua-opts                       alias [deprecated] for script-opts
 --lut                            String (default: ) [file]
 --lut-type                       Choices: auto native normalized conversion (default: auto)
 --mc                             Float (0 to 100) (default: -1.000)
 --media-keys                     alias [deprecated] for input-media-keys
 --media-title                    alias [deprecated] for force-media-title
 --merge-files                    Flag (default: no)
 --metadata-codepage              String (default: utf-8)
 --mf-fps                         Double (default: 1.000)
 --mf-type                        String (default: )
 --mixer                          removed [deprecated]
 --mixer-channel                  removed [deprecated]
 --mkv-subtitle-preroll           alias [deprecated] for demuxer-mkv-subtitle-preroll
 --monitoraspect                  Float (0 to 9) (default: 0.000)
 --monitorpixelaspect             Float (0.03125 to 32) (default: 1.000)
 --mouse-movements                alias [deprecated] for input-cursor
 --msg-color                      Flag (default: yes)
 --msg-level                      Output verbosity levels (default: )
 --msg-module                     Flag (default: no)
 --msg-time                       Flag (default: no)
 --msgcolor                       alias [deprecated] for msg-color
 --msglevel                       removed [deprecated]
 --msgmodule                      alias [deprecated] for msg-module
 --mute                           Choices: no auto yes (default: no)
 --name                           alias [deprecated] for x11-name
 --native-fs                      Flag (default: yes)
 --native-keyrepeat               Flag (default: no)
 --network-timeout                Double (0 to any) (default: 60.000)
 --no-cache-pause-below           removed [deprecated]
 --no-ometadata                   removed [deprecated]
 --noar                           alias [deprecated] for no-input-appleremote
 --noautosub                      alias [deprecated] for no-sub-auto
 --noconsolecontrols              alias [deprecated] for no-input-terminal
 --nosound                        alias [deprecated] for no-audio
 --o                              String (default: ) [not in config files] [file]
 --oac                            String (default: )
 --oacopts                        Key/value list (default: )
    --oacopts-add
    --oacopts-append
    --oacopts-set
    --oacopts-remove
 --oafirst                        Flag (default: no) [deprecated]
 --oaoffset                       Float (-1000000 to 1000000) (default: 0.000) [deprecated]
 --oautofps                       removed [deprecated]
 --ocopy-metadata                 Flag (default: yes)
 --ocopyts                        removed [deprecated]
 --of                             String (default: )
 --ofopts                         Key/value list (default: )
    --ofopts-add
    --ofopts-append
    --ofopts-set
    --ofopts-remove
 --ofps                           removed [deprecated]
 --oharddup                       removed [deprecated]
 --omaxfps                        removed [deprecated]
 --on-all-workspaces              Flag (default: no)
 --oneverdrop                     removed [deprecated]
 --ontop                          Flag (default: no)
 --ontop-level                    Choices: window system desktop (or an integer) (0 to 2147483647) (default: window)
 --openal-direct-channels         Flag (default: yes)
 --openal-num-buffers             Integer (2 to 128) (default: 4)
 --openal-num-samples             Integer (256 to 32768) (default: 8192)
 --opengl-backend                 alias [deprecated] for gpu-context
 --opengl-check-pattern-a         Integer (default: 0)
 --opengl-check-pattern-b         Integer (default: 0)
 --opengl-debug                   alias [deprecated] for gpu-debug
 --opengl-dumb-mode               alias [deprecated] for gpu-dumb-mode
 --opengl-dwmflush                Choices: no auto windowed yes (default: auto)
 --opengl-early-flush             Choices: no yes auto (default: no)
 --opengl-es                      Choices: auto yes no (default: auto)
 --opengl-fbo-format              alias [deprecated] for fbo-format
 --opengl-gamma                   alias [deprecated] for gamma-factor
 --opengl-glfinish                Flag (default: no)
 --opengl-hwdec-interop           alias [deprecated] for gpu-hwdec-interop
 --opengl-pbo                     Flag (default: no)
 --opengl-rectangle-textures      Flag (default: no)
 --opengl-restrict                removed [deprecated]
 --opengl-shader                  alias [deprecated] for glsl-shader
 --opengl-shader-cache-dir        alias [deprecated] for gpu-shader-cache-dir
 --opengl-shaders                 alias [deprecated] for glsl-shaders
 --opengl-sw                      alias [deprecated] for gpu-sw
 --opengl-swapinterval            Integer (default: 1)
 --opengl-tex-pad-x               alias [deprecated] for gpu-tex-pad-x
 --opengl-tex-pad-y               alias [deprecated] for gpu-tex-pad-y
 --opengl-vsync-fences            alias [deprecated] for swapchain-depth
 --opengl-waitvsync               Flag (default: no)
 --orawts                         Flag (default: no)
 --ordered-chapters               Flag (default: yes)
 --ordered-chapters-files         String (default: ) [file]
 --oremove-metadata               String list (default: )
    --oremove-metadata-add
    --oremove-metadata-append
    --oremove-metadata-clr
    --oremove-metadata-del
    --oremove-metadata-pre
    --oremove-metadata-set
    --oremove-metadata-toggle
    --oremove-metadata-remove
 --osc                            Flag (default: yes)
 --osd-align-x                    Choices: left center right (default: left)
 --osd-align-y                    Choices: top center bottom (default: top)
 --osd-back-color                 Color (default: #00000000)
 --osd-bar                        Flag (default: yes)
 --osd-bar-align-x                Float (-1 to 1) (default: 0.000)
 --osd-bar-align-y                Float (-1 to 1) (default: 0.500)
 --osd-bar-h                      Float (0.1 to 50) (default: 3.125)
 --osd-bar-w                      Float (1 to 100) (default: 75.000)
 --osd-blur                       Float (0 to 20) (default: 0.000)
 --osd-bold                       Flag (default: no)
 --osd-border-color               Color (default: #FF000000)
 --osd-border-size                Float (default: 3.000)
 --osd-color                      Color (default: #FFFFFFFF)
 --osd-duration                   Integer (0 to 3600000) (default: 1000)
 --osd-font                       String (default: sans-serif)
 --osd-font-provider              Choices: auto none fontconfig (default: auto)
 --osd-font-size                  Float (1 to 9000) (default: 55.000)
 --osd-fractions                  Flag (default: no)
 --osd-italic                     Flag (default: no)
 --osd-justify                    Choices: auto left center right (default: auto)
 --osd-level                      Choices: 0 1 2 3 (default: 1)
 --osd-margin-x                   Integer (0 to 300) (default: 25)
 --osd-margin-y                   Integer (0 to 600) (default: 22)
 --osd-msg1                       String (default: )
 --osd-msg2                       String (default: )
 --osd-msg3                       String (default: )
 --osd-on-seek                    Choices: no bar msg msg-bar (default: bar)
 --osd-playing-msg                String (default: )
 --osd-playing-msg-duration       Integer (0 to 3600000) (default: 0)
 --osd-scale                      Float (0 to 100) (default: 1.000)
 --osd-scale-by-window            Flag (default: yes)
 --osd-shadow-color               Color (default: #80F0F0F0)
 --osd-shadow-offset              Float (default: 0.000)
 --osd-spacing                    Float (-10 to 10) (default: 0.000)
 --osd-status-msg                 String (default: )
 --osdlevel                       alias [deprecated] for osd-level
 --oset-metadata                  Key/value list (default: )
    --oset-metadata-add
    --oset-metadata-append
    --oset-metadata-set
    --oset-metadata-remove
 --ovc                            String (default: )
 --ovcopts                        Key/value list (default: )
    --ovcopts-add
    --ovcopts-append
    --ovcopts-set
    --ovcopts-remove
 --override-display-fps           Double (0 to any) (default: 0.000)
 --ovfirst                        Flag (default: no) [deprecated]
 --ovoffset                       Float (-1000000 to 1000000) (default: 0.000) [deprecated]
 --panscan                        Float (0 to 1) (default: 0.000)
 --panscanrange                   removed [deprecated]
 --pause                          Flag (default: no)
 --play-dir                       Choices: forward + backward - (default: forward)
 --player-operation-mode          Choices: cplayer pseudo-gui (default: cplayer)
 --playing-msg                    alias [deprecated] for term-playing-msg
 --playlist                       String (default: ) [not in config files] [file]
 --playlist-start                 Choices: auto no (or an integer) (0 to 2147483647) (default: auto)
 --pp                             removed [deprecated]
 --pphelp                         removed [deprecated]
 --prefetch-playlist              Flag (default: no)
 --priority                       Choices: no realtime high abovenormal normal belownormal idle (default: no)
 --profile                        String list (default: )
    --profile-add
    --profile-append
    --profile-clr
    --profile-del
    --profile-pre
    --profile-set
    --profile-toggle
    --profile-remove
 --quiet                          Flag (default: no)
 --rar-list-all-volumes           Flag (default: no)
 --rawaudio                       removed [deprecated]
 --rawvideo                       removed [deprecated]
 --really-quiet                   Flag (default: no)
 --rebase-start-time              Flag (default: yes)
 --record-file                    String (default: ) [file] [deprecated]
 --referrer                       String (default: )
 --replaygain                     Choices: no track album (default: no)
 --replaygain-clip                Flag (default: no)
 --replaygain-fallback            Float (-200 to 60) (default: 0.000)
 --replaygain-preamp              Float (-150 to 150) (default: 0.000)
 --reset-on-next-file             String list (default: )
    --reset-on-next-file-add
    --reset-on-next-file-append
    --reset-on-next-file-clr
    --reset-on-next-file-del
    --reset-on-next-file-pre
    --reset-on-next-file-set
    --reset-on-next-file-toggle
    --reset-on-next-file-remove
 --resume-playback                Flag (default: yes)
 --resume-playback-check-mtime    Flag (default: no)
 --right-alt-gr                   alias [deprecated] for input-right-alt-gr
 --rtsp-transport                 Choices: lavf udp tcp http udp_multicast (default: tcp)
 --saturation                     Integer (-100 to 100) (default: 0)
 --save-position-on-quit          Flag (default: no)
 --scale                          String (default: bilinear)
 --scale-antiring                 Float (0 to 1) (default: 0.000)
 --scale-blur                     Float (default: 0.000)
 --scale-clamp                    Float (0 to 1) (default: 0.000)
 --scale-cutoff                   Float (0 to 1) (default: 0.001)
 --scale-param1                   Float (default: default)
 --scale-param2                   Float (default: default)
 --scale-radius                   Float (0.5 to 16) (default: 0.000)
 --scale-taper                    Float (0 to 1) (default: 0.000)
 --scale-wblur                    Float (default: 0.000)
 --scale-window                   String (default: )
 --scale-wparam                   Float (default: default)
 --scale-wtaper                   Float (0 to 1) (default: 0.000)
 --scaler-lut-size                Integer (4 to 10) (default: 6)
 --scaler-resizes-only            Flag (default: yes)
 --screen                         Choices: default (or an integer) (0 to 32) (default: default)
 --screen-name                    String (default: )
 --screenshot-directory           String (default: ) [file]
 --screenshot-format              Choices: jpg jpeg png webp jxl (default: jpg)
 --screenshot-high-bit-depth      Flag (default: yes)
 --screenshot-jpeg-quality        Integer (0 to 100) (default: 90)
 --screenshot-jpeg-source-chroma  Flag (default: yes)
 --screenshot-jxl-distance        Double (0 to 15) (default: 1.000)
 --screenshot-jxl-effort          Integer (1 to 9) (default: 3)
 --screenshot-png-compression     Integer (0 to 9) (default: 7)
 --screenshot-png-filter          Integer (0 to 5) (default: 5)
 --screenshot-sw                  Flag (default: no)
 --screenshot-tag-colorspace      Flag (default: no)
 --screenshot-template            String (default: mpv-shot%n)
 --screenshot-webp-compression    Integer (0 to 6) (default: 4)
 --screenshot-webp-lossless       Flag (default: no)
 --screenshot-webp-quality        Integer (0 to 100) (default: 75)
 --script                         alias for --scripts-append (CLI/config files only)
 --script-opts                    Key/value list (default: )
    --script-opts-add
    --script-opts-append
    --script-opts-set
    --script-opts-remove
 --scripts                        String list (default: ) [file]
    --scripts-add
    --scripts-append
    --scripts-clr
    --scripts-del
    --scripts-pre
    --scripts-set
    --scripts-toggle
    --scripts-remove
 --sdl-buflen                     Float (default: 0.000)
 --sdl-sw                         Flag (default: no)
 --sdl-switch-mode                Flag (default: no)
 --sdl-vsync                      Flag (default: yes)
 --secondary-sid                  Choices: no auto (or an integer) (0 to 8190) (default: no)
 --secondary-sub-visibility       Flag (default: yes)
 --sharpen                        Float (default: 0.000)
 --show-profile                   String (default: ) [not in config files]
 --shuffle                        Flag (default: no)
 --sid                            Choices: no auto (or an integer) (0 to 8190) (default: auto)
 --sigmoid-center                 Float (0 to 1) (default: 0.750)
 --sigmoid-slope                  Float (1 to 20) (default: 6.500)
 --sigmoid-upscaling              Flag (default: no)
 --slang                          String list (default: )
    --slang-add
    --slang-append
    --slang-clr
    --slang-del
    --slang-pre
    --slang-set
    --slang-toggle
    --slang-remove
 --snap-window                    Flag (default: no)
 --softvol-max                    alias [deprecated] for volume-max
 --speed                          Double (0.01 to 100) (default: 1.000)
 --spirv-compiler                 Choices: auto shaderc (default: auto)
 --spugauss                       alias [deprecated] for sub-gauss
 --srate                          alias [deprecated] for audio-samplerate
 --ss                             alias [deprecated] for start
 --sstep                          Double (0 to any) (default: 0.000)
 --start                          Relative time or percent position (default: none)
 --status-msg                     alias [deprecated] for term-status-msg
 --stop-playback-on-init-failure  Flag (default: no)
 --stop-screensaver               Choices: no yes always (default: yes)
 --stop-xscreensaver              alias [deprecated] for stop-screensaver
 --stream-buffer-size             ByteSize (4096 to 536870912) (default: 128.000 KiB)
 --stream-capture                 removed [deprecated]
 --stream-dump                    String (default: ) [file]
 --stream-lavf-o                  Key/value list (default: )
    --stream-lavf-o-add
    --stream-lavf-o-append
    --stream-lavf-o-set
    --stream-lavf-o-remove
 --stream-record                  String (default: )
 --stretch-dvd-subs               Flag (default: no)
 --stretch-image-subs-to-screen   Flag (default: no)
 --sub                            alias for sid
 --sub-align-x                    Choices: left center right (default: center)
 --sub-align-y                    Choices: top center bottom (default: bottom)
 --sub-ass                        Flag (default: yes)
 --sub-ass-force-margins          Flag (default: no)
 --sub-ass-force-style            String list (default: )
    --sub-ass-force-style-add
    --sub-ass-force-style-append
    --sub-ass-force-style-clr
    --sub-ass-force-style-del
    --sub-ass-force-style-pre
    --sub-ass-force-style-set
    --sub-ass-force-style-toggle
    --sub-ass-force-style-remove
 --sub-ass-hinting                Choices: none light normal native (default: none)
 --sub-ass-justify                Flag (default: no)
 --sub-ass-line-spacing           Float (-1000 to 1000) (default: 0.000)
 --sub-ass-override               Choices: no yes force scale strip (default: yes)
 --sub-ass-scale-with-window      Flag (default: no)
 --sub-ass-shaper                 Choices: simple complex (default: complex)
 --sub-ass-style-override         alias [deprecated] for sub-ass-override
 --sub-ass-styles                 String (default: ) [file]
 --sub-ass-vsfilter-aspect-compat Flag (default: yes)
 --sub-ass-vsfilter-blur-compat   Flag (default: yes)
 --sub-ass-vsfilter-color-compat  Choices: no basic full force-601 (default: basic)
 --sub-auto                       Choices: no exact fuzzy all (default: exact)
 --sub-back-color                 Color (default: #00000000)
 --sub-blur                       Float (0 to 20) (default: 0.000)
 --sub-bold                       Flag (default: no)
 --sub-border-color               Color (default: #FF000000)
 --sub-border-size                Float (default: 3.000)
 --sub-clear-on-seek              Flag (default: no)
 --sub-codepage                   String (default: auto)
 --sub-color                      Color (default: #FFFFFFFF)
 --sub-create-cc-track            Flag (default: no)
 --sub-delay                      Float (default: 0.000)
 --sub-demuxer                    String (default: )
 --sub-file                       alias for --sub-files-append (CLI/config files only)
 --sub-file-paths                 String list (default: ) [file]
    --sub-file-paths-add
    --sub-file-paths-append
    --sub-file-paths-clr
    --sub-file-paths-del
    --sub-file-paths-pre
    --sub-file-paths-set
    --sub-file-paths-toggle
    --sub-file-paths-remove
 --sub-files                      String list (default: ) [file]
    --sub-files-add
    --sub-files-append
    --sub-files-clr
    --sub-files-del
    --sub-files-pre
    --sub-files-set
    --sub-files-toggle
    --sub-files-remove
 --sub-filter-jsre                String list (default: )
    --sub-filter-jsre-add
    --sub-filter-jsre-append
    --sub-filter-jsre-clr
    --sub-filter-jsre-del
    --sub-filter-jsre-pre
    --sub-filter-jsre-set
    --sub-filter-jsre-toggle
    --sub-filter-jsre-remove
 --sub-filter-regex               String list (default: )
    --sub-filter-regex-add
    --sub-filter-regex-append
    --sub-filter-regex-clr
    --sub-filter-regex-del
    --sub-filter-regex-pre
    --sub-filter-regex-set
    --sub-filter-regex-toggle
    --sub-filter-regex-remove
 --sub-filter-regex-enable        Flag (default: yes)
 --sub-filter-regex-plain         Flag (default: no)
 --sub-filter-regex-warn          Flag (default: no)
 --sub-filter-sdh                 Flag (default: no)
 --sub-filter-sdh-harder          Flag (default: no)
 --sub-fix-timing                 Flag (default: no)
 --sub-font                       String (default: sans-serif)
 --sub-font-provider              Choices: auto none fontconfig (default: auto)
 --sub-font-size                  Float (1 to 9000) (default: 55.000)
 --sub-forced-only                Choices: auto no yes (default: auto)
 --sub-fps                        Float (default: 0.000)
 --sub-fuzziness                  alias [deprecated] for sub-auto
 --sub-gauss                      Float (0 to 3) (default: 0.000)
 --sub-gray                       Flag (default: no)
 --sub-italic                     Flag (default: no)
 --sub-justify                    Choices: auto left center right (default: auto)
 --sub-margin-x                   Integer (0 to 300) (default: 25)
 --sub-margin-y                   Integer (0 to 600) (default: 22)
 --sub-past-video-end             Flag (default: no)
 --sub-paths                      alias [deprecated] for sub-file-paths
 --sub-pos                        Integer (0 to 150) (default: 100)
 --sub-scale                      Float (0 to 100) (default: 1.000)
 --sub-scale-by-window            Flag (default: yes)
 --sub-scale-with-window          Flag (default: yes)
 --sub-shadow-color               Color (default: #80F0F0F0)
 --sub-shadow-offset              Float (default: 0.000)
 --sub-spacing                    Float (-10 to 10) (default: 0.000)
 --sub-speed                      Float (default: 1.000)
 --sub-text-align-x               alias [deprecated] for sub-align-x
 --sub-text-align-y               alias [deprecated] for sub-align-y
 --sub-text-back-color            alias [deprecated] for sub-back-color
 --sub-text-blur                  alias [deprecated] for sub-blur
 --sub-text-bold                  alias [deprecated] for sub-bold
 --sub-text-border-color          alias [deprecated] for sub-border-color
 --sub-text-border-size           alias [deprecated] for sub-border-size
 --sub-text-color                 alias [deprecated] for sub-color
 --sub-text-font                  alias [deprecated] for sub-font
 --sub-text-font-size             alias [deprecated] for sub-font-size
 --sub-text-italic                alias [deprecated] for sub-italic
 --sub-text-margin-x              alias [deprecated] for sub-margin-x
 --sub-text-margin-y              alias [deprecated] for sub-margin-y
 --sub-text-shadow-color          alias [deprecated] for sub-shadow-color
 --sub-text-shadow-offset         alias [deprecated] for sub-shadow-offset
 --sub-text-spacing               alias [deprecated] for sub-spacing
 --sub-use-margins                Flag (default: yes)
 --sub-visibility                 Flag (default: yes)
 --subcp                          alias [deprecated] for sub-codepage
 --subdelay                       alias [deprecated] for sub-delay
 --subfile                        alias [deprecated] for sub-file
 --subfont                        alias [deprecated] for sub-text-font
 --subfont-text-scale             alias [deprecated] for sub-scale
 --subfps                         alias [deprecated] for sub-fps
 --subpos                         alias [deprecated] for sub-pos
 --subs-with-matching-audio       Flag (default: yes)
 --swapchain-depth                Integer (1 to 8) (default: 3)
 --sws-allow-zimg                 Flag (default: yes)
 --sws-bitexact                   Flag (default: no)
 --sws-cgb                        Float (0 to 100) (default: 0.000)
 --sws-chs                        Integer (default: 0)
 --sws-cs                         Float (-100 to 100) (default: 0.000)
 --sws-cvs                        Integer (default: 0)
 --sws-fast                       Flag (default: no)
 --sws-lgb                        Float (0 to 100) (default: 0.000)
 --sws-ls                         Float (-100 to 100) (default: 0.000)
 --sws-scaler                     Choices: fast-bilinear bilinear bicubic x point area bicublin gauss sinc lanczos spline (default: lanczos)
 --target-colorspace-hint         Flag (default: no)
 --target-lut                     String (default: ) [file]
 --target-peak                    Choices: auto (or an integer) (10 to 10000) (default: auto)
 --target-prim                    Choices: auto bt.601-525 bt.601-625 bt.709 bt.2020 bt.470m apple adobe prophoto cie1931 dci-p3 display-p3 v-gamut s-gamut (default: auto)
 --target-trc                     Choices: auto bt.1886 srgb linear gamma1.8 gamma2.0 gamma2.2 gamma2.4 gamma2.6 gamma2.8 prophoto pq hlg v-log s-log1 s-log2 (default: auto)
 --taskbar-progress               Flag (default: yes)
 --teletext-page                  Integer (1 to 999) (default: 100)
 --temporal-dither                Flag (default: no)
 --temporal-dither-period         Integer (1 to 128) (default: 1)
 --term-osd                       Choices: force auto no (default: auto)
 --term-osd-bar                   Flag (default: no)
 --term-osd-bar-chars             String (default: [-+-])
 --term-playing-msg               String (default: )
 --term-status-msg                String (default: )
 --term-title                     String (default: )
 --terminal                       Flag (default: yes)
 --title                          String (default: ${?media-title:${media-title}}${!media-title:No file} - mpv)
 --tls-ca-file                    String (default: ) [file]
 --tls-cert-file                  String (default: ) [file]
 --tls-key-file                   String (default: ) [file]
 --tls-verify                     Flag (default: no)
 --tone-mapping                   Choices: auto clip mobius reinhard hable gamma linear spline bt.2390 bt.2446a (default: auto)
 --tone-mapping-crosstalk         Float (0 to 0.3) (default: 0.040)
 --tone-mapping-desaturate        removed [deprecated]
 --tone-mapping-desaturate-exponent removed [deprecated]
 --tone-mapping-max-boost         Float (1 to 10) (default: 1.000)
 --tone-mapping-mode              Choices: auto rgb max hybrid luma (default: auto)
 --tone-mapping-param             Float (default: default)
 --track-auto-selection           Flag (default: yes)
 --tscale                         String (default: mitchell)
 --tscale-antiring                Float (0 to 1) (default: 0.000)
 --tscale-blur                    Float (default: 0.000)
 --tscale-clamp                   Float (0 to 1) (default: 1.000)
 --tscale-cutoff                  Float (0 to 1) (default: 0.000)
 --tscale-param1                  Float (default: default)
 --tscale-param2                  Float (default: default)
 --tscale-radius                  Float (0.5 to 16) (default: 0.000)
 --tscale-taper                   Float (0 to 1) (default: 0.000)
 --tscale-wblur                   Float (default: 0.000)
 --tscale-window                  String (default: )
 --tscale-wparam                  Float (default: default)
 --tscale-wtaper                  Float (0 to 1) (default: 0.000)
 --tvscan                         alias [deprecated] for tv-scan
 --untimed                        Flag (default: no)
 --use-embedded-icc-profile       Flag (default: yes)
 --use-filedir-conf               Flag (default: no)
 --use-filename-title             removed [deprecated]
 --user-agent                     String (default: libmpv)
 --V                              Print [not in config files]
 --v                              Flag [not in config files]
 --vc                             removed [deprecated]
 --vd                             String (default: )
 --vd-lavc-assume-old-x264        Flag (default: no)
 --vd-lavc-bitexact               Flag (default: no)
 --vd-lavc-check-hw-profile       Flag (default: yes)
 --vd-lavc-dr                     Flag (default: yes)
 --vd-lavc-fast                   Flag (default: no)
 --vd-lavc-film-grain             Choices: auto cpu gpu (default: auto)
 --vd-lavc-framedrop              Choices: none default nonref bidir nonkey all (default: nonref)
 --vd-lavc-o                      Key/value list (default: )
    --vd-lavc-o-add
    --vd-lavc-o-append
    --vd-lavc-o-set
    --vd-lavc-o-remove
 --vd-lavc-show-all               Flag (default: no)
 --vd-lavc-skipframe              Choices: none default nonref bidir nonkey all (default: default)
 --vd-lavc-skipidct               Choices: none default nonref bidir nonkey all (default: default)
 --vd-lavc-skiploopfilter         Choices: none default nonref bidir nonkey all (default: default)
 --vd-lavc-software-fallback      Choices: no yes (or an integer) (1 to 2147483647) (default: 3)
 --vd-lavc-threads                Integer (0 to any) (default: 0)
 --vd-queue-enable                Flag (default: no)
 --vd-queue-max-bytes             ByteSize (0 to 4.6116860184274e+18) (default: 512.000 MiB)
 --vd-queue-max-samples           Integer64 (0 to any) (default: 50)
 --vd-queue-max-secs              Double (0 to any) (default: 2.000)
 --version                        Print [not in config files]
 --vf                             Object settings list (default: )
    --vf-add
    --vf-append
    --vf-clr
    --vf-del
    --vf-help
    --vf-pre
    --vf-set
    --vf-toggle
    --vf-remove
 --vf-defaults                    Object settings list (default: ) [deprecated]
    --vf-defaults-add
    --vf-defaults-append
    --vf-defaults-clr
    --vf-defaults-del
    --vf-defaults-help
    --vf-defaults-pre
    --vf-defaults-set
    --vf-defaults-toggle
    --vf-defaults-remove
 --vid                            Choices: no auto (or an integer) (0 to 8190) (default: auto)
 --video                          alias for vid
 --video-align-x                  Float (-1 to 1) (default: 0.000)
 --video-align-y                  Float (-1 to 1) (default: 0.000)
 --video-aspect                   alias [deprecated] for video-aspect-override
 --video-aspect-method            Choices: bitstream container (default: container)
 --video-aspect-override          Aspect (-1 to 10) (default: -1.000)
 --video-backward-batch           Integer (0 to 1024) (default: 1)
 --video-backward-overlap         Choices: auto (or an integer) (0 to 1024) (default: auto)
 --video-latency-hacks            Flag (default: no)
 --video-margin-ratio-bottom      Float (0 to 1) (default: 0.000)
 --video-margin-ratio-left        Float (0 to 1) (default: 0.000)
 --video-margin-ratio-right       Float (0 to 1) (default: 0.000)
 --video-margin-ratio-top         Float (0 to 1) (default: 0.000)
 --video-osd                      Flag (default: yes)
 --video-output-levels            Choices: auto limited full (default: auto)
 --video-pan-x                    Float (-3 to 3) (default: 0.000)
 --video-pan-y                    Float (-3 to 3) (default: 0.000)
 --video-reversal-buffer          ByteSize (0 to 4.6116860184274e+18) (default: 1.000 GiB)
 --video-rotate                   Choices: no (or an integer) (0 to 359) (default: 0)
 --video-scale-x                  Float (0 to 10000) (default: 1.000)
 --video-scale-y                  Float (0 to 10000) (default: 1.000)
 --video-stereo-mode              removed [deprecated]
 --video-sync                     Choices: audio display-resample display-resample-vdrop display-resample-desync display-adrop display-vdrop display-desync desync (default: audio)
 --video-sync-max-audio-change    Double (0 to 1) (default: 0.125)
 --video-sync-max-factor          Integer (1 to 10) (default: 5)
 --video-sync-max-video-change    Double (0 to any) (default: 1.000)
 --video-timing-offset            Double (0 to 1) (default: 0.050)
 --video-unscaled                 Choices: no yes downscale-big (default: no)
 --video-zoom                     Float (-20 to 20) (default: 0.000)
 --vlang                          String list (default: )
    --vlang-add
    --vlang-append
    --vlang-clr
    --vlang-del
    --vlang-pre
    --vlang-set
    --vlang-toggle
    --vlang-remove
 --vo                             Object settings list (default: )
    --vo-add
    --vo-append
    --vo-clr
    --vo-del
    --vo-help
    --vo-pre
    --vo-set
    --vo-toggle
    --vo-remove
 --vo-direct3d-disable-texture-align Flag (default: no)
 --vo-direct3d-exact-backbuffer   Flag (default: no)
 --vo-direct3d-force-power-of-2   Flag (default: no)
 --vo-direct3d-swap-discard       Flag (default: no)
 --vo-direct3d-texture-memory     Choices: default managed default-pool default-pool-shadow scratch (default: default)
 --vo-image-format                Choices: jpg jpeg png webp jxl (default: jpg)
 --vo-image-high-bit-depth        Flag (default: yes)
 --vo-image-jpeg-quality          Integer (0 to 100) (default: 90)
 --vo-image-jpeg-source-chroma    Flag (default: yes)
 --vo-image-jxl-distance          Double (0 to 15) (default: 1.000)
 --vo-image-jxl-effort            Integer (1 to 9) (default: 3)
 --vo-image-outdir                String (default: ) [file]
 --vo-image-png-compression       Integer (0 to 9) (default: 7)
 --vo-image-png-filter            Integer (0 to 5) (default: 5)
 --vo-image-tag-colorspace        Flag (default: no)
 --vo-image-webp-compression      Integer (0 to 6) (default: 4)
 --vo-image-webp-lossless         Flag (default: no)
 --vo-image-webp-quality          Integer (0 to 100) (default: 75)
 --vo-mmcss-profile               String (default: Playback)
 --vo-null-fps                    Double (0 to 10000) (default: 0.000)
 --vo-tct-256                     Flag (default: no)
 --vo-tct-algo                    Choices: plain half-blocks (default: half-blocks)
 --vo-tct-height                  Integer (default: 0)
 --vo-tct-width                   Integer (default: 0)
 --vobsub                         removed [deprecated]
 --volstep                        removed [deprecated]
 --volume                         Float (-1 to 1000) (default: 100.000)
 --volume-max                     Float (100 to 1000) (default: 130.000)
 --vulkan-async-compute           Flag (default: yes)
 --vulkan-async-transfer          Flag (default: yes)
 --vulkan-device                  String (default: )
 --vulkan-disable-events          Flag (default: no)
 --vulkan-display-display         Integer (default: 0)
 --vulkan-display-mode            Integer (default: 0)
 --vulkan-display-plane           Integer (default: 0)
 --vulkan-queue-count             Integer (1 to 8) (default: 1)
 --vulkan-swap-mode               Choices: auto fifo fifo-relaxed mailbox immediate (default: auto)
 --watch-later-directory          String (default: ) [file]
 --watch-later-options            String list (default: osd-level,speed,edition,pause,volume,mute,audio-delay,fullscreen,ontop,border,gamma,brightness,contrast,saturation,hue,deinterlace,vf,af,panscan,aid,vid,sid,sub-delay,sub-speed,sub-pos,sub-visibility,sub-scale,sub-use-margins,sub-ass-force-margins,sub-ass-vsfilter-aspect-compat,sub-ass-override,ab-loop-a,ab-loop-b,video-aspect-override)
    --watch-later-options-add
    --watch-later-options-append
    --watch-later-options-clr
    --watch-later-options-del
    --watch-later-options-pre
    --watch-later-options-set
    --watch-later-options-toggle
    --watch-later-options-remove
 --wayland-app-id                 String (default: mpv)
 --wid                            Integer64 (default: -1)
 --window-dragging                Flag (default: yes)
 --window-maximized               Flag (default: no)
 --window-minimized               Flag (default: no)
 --window-scale                   Double (0.001 to 100) (default: 1.000)
 --write-filename-in-watch-later-config Flag (default: no)
 --x11-name                       String (default: )
 --xineramascreen                 removed [deprecated]
 --xy                             removed [deprecated]
 --ytdl                           Flag (default: yes)
 --ytdl-format                    String (default: )
 --ytdl-raw-options               Key/value list (default: )
    --ytdl-raw-options-add
    --ytdl-raw-options-append
    --ytdl-raw-options-set
    --ytdl-raw-options-remove
 --zimg-dither                    Choices: no ordered random error-diffusion (default: random)
 --zimg-fast                      Flag (default: yes)
 --zimg-scaler                    Choices: point bilinear bicubic spline16 spline36 lanczos (default: lanczos)
 --zimg-scaler-chroma             Choices: point bilinear bicubic spline16 spline36 lanczos (default: bilinear)
 --zimg-scaler-chroma-param-a     Double (default: default)
 --zimg-scaler-chroma-param-b     Double (default: default)
 --zimg-scaler-param-a            Double (default: default)
 --zimg-scaler-param-b            Double (default: default)
 --zimg-threads                   Choices: auto (or an integer) (1 to 64) (default: auto)
 --zoom                           removed [deprecated]
 --{                              Flag [not in config files]
 --}                              Flag [not in config files]

Total: 1110 options

#>

