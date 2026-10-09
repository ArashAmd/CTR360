#include <stdio.h>
#include <xenon.h>
#include <console/console.h>
#include <usb/usbmain.h>
#include <input/input.h>

int main(void)
{
    struct controller_data_s pad;

    xenos_init(VIDEO_MODE_AUTO);
    console_init();
    xenon_make_it_faster(XENON_SPEED_FULL);
    usb_init();

    console_clear();
    printf("CTR360 - Xbox 360 native boot test\n");
    printf("----------------------------------\n");
    printf("If you can read this, the native app booted.\n");
    printf("Press Y or Guide to exit.\n\n");

    for (;;) {
        usb_do_poll();
        get_controller_data(0, &pad);
        if (pad.y || pad.logo)
            break;
    }

    return 0;
}
