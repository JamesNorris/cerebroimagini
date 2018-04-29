#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/usb.h>

int vendorID;
int productID;
char name[50];

//usb_devID
static struct usb_device_id skel_table[] = {
  //usb_vendor,usb_product
  {USB_DEVICE(vendorID, productID)},
  {}
};
MODULE_DEVICE_TABLE (usb, skel_table);

//usb_driver
static struct usb_driver skel_driver = {
  .name = name,
  .id_table = skel_table,
  .probe = skel_probe,
  .disconnect = skel_disconnect,
};

//usb_probe
static int skel_probe(struct usb_interface *interface, const struct usb_device_id *id){
  return 0;
}

//usb_disconnect
static void skel_disconnect(struct usb_interface *interface){
}

//usb_init
static int __init usb_skel_init(void){
  int result;
  result = usb_register(&skel_driver);
  if (result < 0) {
                err("usb_register failed for the "__FILE__ "driver."
                    "Error number %d", result);
                return -1;
        }
  return 0;
}

//usb_destructor
static void __exit usb_skel_exit(void){
  usb_deregister(&skel_driver);
}

module_init(usb_skel_init);
module_exit(usb_skel_exit);


MODULE_LICENSE("GPL");
MODULE_AUTHOR("CereboIMG");
MODULE_DESCRIPTION("USB Driver for CerebroIMG");
