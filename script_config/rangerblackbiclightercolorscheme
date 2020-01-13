from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color   import*

class redmoon(ColorScheme):
    progress_bar_color = white

    def use(self, context):
        fg, bg, attr = default_colors

        if context.reset:
            return default_colors

        elif context.in_browser:
            if context.selected:
                attr = invisible
            else:
                attr = normal
            if context.empty or context.error:
                fg = 210
                bg = black
            if context.border:
                fg = 210
                bg = black
            if context.image:
                fg = 210
                bg = black
            if context.video:
                fg = 210
                bg = black
            if context.audio:
                fg = 210
                bg = black
            if context.document:
                fg = 210
                bg = black
            if context.container:
                attr |= normal
            if context.directory:
                attr |= normal
                fg = 210
                bg = black
            elif context.executable and not \
                    any((context.media, context.container,
                        context.fifo, context.socket)):
                attr |= normal
                fg = 210
                bg = black
            if context.socket:
                fg = 210
                bg = black
                attr |= normal
            if context.fifo or context.device:
                fg = 210
                bg = black
                if context.device:
                    attr |= normal
            if context.link:
                fg = context.good and white
                bg = black
            if context.bad:
                fg = 147
                bg = black
            if context.tag_marker and not context.selected:
                attr |= normal
                if fg in (210, 147):
                    fg = 210
                else:
                    fg = 147
            if not context.selected and (context.cut or context.copied):
                fg = 210
                bg = black
            if context.main_column:
                if context.selected:
                    attr |= normal
                if context.marked:
                    attr |= normal
                    fg = 8
                if context.badinfo:
                    if attr & normal:
                        bg =1
                    else:
                        fg = 7
        elif context.in_titlebar:
            attr |= normal
            if context.hostname:
                fg = 210
                bg = black
            elif context.directory:
                fg = 210
                bg = black
            elif context.tab:
                if context.good:
                    fg = 210
            elif context.link:
                fg = 210
        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = 210
                    bg = black
                elif context.bad:
                    fg = 210
            if context.marked:
                attr |= normal | normal
                fg = 210
                bg = black
            if context.loaded:
                bg = self.progress_bar_color
            if context.vcsinfo:
                fg = 210
                bg = black
            if context.vcscommit:
                fg = white
                attr &= ~normal

        if context.text:
            if context.higlight:
                attr |= normal

        if context.in_taskview:
            if context.title:
                fg = 210
                bg = black

            if context.selected:
                attr |= underline

            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color

        if context.vcsfile and not context.selected:
            attr &= ~normal
            if context.vcsconflict:
                fg = white
            elif context.vcschanged:
                fg = white
            elif context.vcsunknown:
                fg = white
            elif context.vcsstaged:
                fg = white
            elif context.vcssync:
                fg = white
            elif context.vcsignored:
                fg = white

        elif context.vcsremote and not context.selected:
            attr &= ~normal
            if context.vcssync:
                fg = white
            elif context.vcsbehind:
                fg = white
                
        elif context.vcsremote and not context.selected:
            attr &= ~normal
            if context.vcssync:
                fg = white
            elif context.vcsbehind:
                fg = white
            elif context.vcsahead:
                fg = white
            elif context.vcsdiverged:
                fg = white
            elif context.vcsunknown:
                fg = white

        return fg, bg, attr
