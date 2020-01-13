

INSTALLATION ARCHLINUX THEN SELINUX LINUX SECURITY MODULE
STAGE ONE:
SECURELY WIPING THE CONTAINER USING EITHER HDPARM OR CRYPTSETUP

STAGE TWO:
USING DM-CRYPT TO ENCRYPT YOUR HARDDRIVE - ENCRYTPED /BOOT AND A DETACHED LUKS HEADER ON USB PREPARING MAIN DRIVE
	PARTITIONING
		SETTING LOGICAL VOLUME MANAGEMENT
			INITIAL BOOT


STAGE THREE:
SETTING USER ACCESS AND SECURITY
SETTING GRAPHICAL USER INTERFACE
SETTING VIRTUAL TESTING ENVIRONMENT 
	SETTING SELINUX WITHIN VIRTUAL ENVIRONMENT

HAJIME 
FIRST STAGE: SECURE ERASURE OF HARDRIVE 	
WARNING: DO NOT USE THESE COMMANDS ON A DRIVE NOT DIRECTLY CONNECTED TO A SATA INTERFACE
WARNING: THIS WILL PERMANENTLY ERASE WHATEVER DATA IS CONTAINED ON THE DRIVE 

HDPARM COMMANDS
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| hdparm -I /dev/sdX (since using arch linux we'll presupose this is /dev/sda)                                                                                                                                                                                                                                                                                                     |
|                                                                                                                                                                                                                                                                                                                                                                                                                      |
|	Security:                                                                                                                                                                                                                                                                                                                                                                                        |
|		Master password revision code = 65534                                                                                                                                                                                                                                                                                                                                    |
|			supported                                                                                                                                                                                                                                                                                                                                                                                  |
|		not 	enabled                                                                                                                                                                                                                                                                                                                                                                                   |
| 		not	locked                                                                                                                                                                                                                                                                                                                                                                               |
|		not	frozen                                                                                                                                                                                                                                                                                                                                                                         |
|		not	expired: security count                                                                                                                                                                                                                                                                                                                                                     |
|			supported: enhanced erase                                                                                                                                                                                                                                                                                                                                                     |
|		2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.                                                                                                                                                                                                                                                              |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UNFREEZING THE DRIVE
if the output above, termed the command output, shows "frozen"  without the superceeding "not" then the following commands will not work. 
Having this occur myself, following the guide provided in cited sources section I didnt forget to add at the end, one runs the command
---_------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # echo -n mem > /sys/power/state                                                                                                                                                                                                                                                                                                                   |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
running this command will put the computer into a normal sleep state that just requires one wake the laptop using the power button. 
as a more in depth aside. Many BIOSes protect drives with an enabled password (security enabled) by issuing a SECURITY FREEZE command before booting an operating system. If your drive is frozen, with password enabled, removing said password using the BIOS and powering down the system may disable the SECURITY FREEZE. Worst case scenario a user would need to use a different motherboard utilizing a different enabled BIOS

WARNING FOLLWING METHOD MAY CRASH KERNEL 

SATA: SATA stands for Serial ATA, a computer bus interface that connects host bus adapters to mass storage devices. These mass storage devices may be hard drives, optical drives, or solid-state drives. 
If one is using a SATA drive then the following may be an option for getting a "not frozen", hot-plugging

HOT-PLUGGING: the ability to add and remove devices to a computer system while the computer is running and have the operating system automatically recognize the change. To verify this check your device follows the two bus standards that support hot plugging, the more obvious Universal Serial Bus (usb) as well as the IEEE 1394. PCMCIA  as well. More than likely your SATA drive does. In addition, note the difference between hot plugging and hot swapping, where the former requires running administrative commands to carry out. This means mounting a hard drive after the new drive has been installed. While this should not matter for this exercise, ATA secure erase, given that the drive will be mounted at boot, hypothetically connecting another drive through another SATA interface anteceeding booting a system would require linux commands for /mounting to perform correctly.

For SATA drives it may be possible to unfreeze through hot replugging the data cable. If this crashes the kernel try letting the operating sytem fully boot up, then quickly hot-(re)plug both the SATA power and data cables. 
If one is using an IDE drive such as an HDD or CD-ROM under no circumstances should a user connect/disconnect/swap power cables while the computer is running. In other words do not disturb the connection with power actively supplied. 
That being said, do so at your own risk, and the above echo command should work for SATA drives as well as SSDs. Surprise, now you know. 

SET USER PASSWORD
---------------------------------------------------------------------------------------------------------------
| # hdparm --user-master u --security-set-pass Entschuldigung /dev/sda                                   |
---------------------------------------------------------------------------------------------------------------
(entschuldigung means excuse me in german)

COMMAND OUTPUT
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| command output                                                                                                                                                                                                     |         
|	security_password="Entschuldigung"                                                                                                                                                         |
|	/dev/sda:                                                                                                                                                                                                    |
|	Issuing SECURITY_SET_PASS command, password="Entschuldigung", user=user, mode=high                                                               |
|	hdparm -I /dev/sda                                                                                                                                                                                        |
|                                                                                                                                                                                                                           |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

MAKE SURE PASSWORD SET SUCCEDED
to check the above was completeled succesfully run the command:
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # hdparm -I /dev/X                                                                                                                                                                                                  |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

COMMAND OUTPUT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Security:                                                                                                                                                                                                                  |
|	Master password revision code = 65534                                                                                                                                                    |
|		supported                                                                                                                                                                                               |
|		enabled                                                                                                                                                                                             |
|	not	locked                 				                                                                                                                                                      |
|	not	frozen     						 	                                                                                                                                        |
|	not 	expired: enhanced erase.                                                                                                                                                                 |
|		supported: enhanced erase                                                                                                                                                                    |
|	Security level high                                                                                                                                                                                               |
|	2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT                                                                          |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ISSUE ATA SECURE ERASE COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # time hdparm --use-master u --security-erase Entschuldigung /dev/X                                                                                                                                                                                                                                                                                                                                       |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

COMMAND OUTPUT
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| security_password="Entschuldigung"                                                                                                                                                                              |
|                                                                                                                                                                                                                                     |
|	/dev/sdd:                                                                                                                                                                                                                    | 
| Issuing SECURITY_ERASE command, password="Entschuldigung", user=user                                                                                                   |
| 0.000u 0.000s 0:39.71 0.0%		0+0k. 0+0io. 0pf+0w                                                                                                                                              |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DRIVE ERASED
following the above commands and with success drive security should now be disabled (no longer should there be a password for access) To verify run command:
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # hdparm -I /dev/X									                                                                                                                                                                                                                                                                                                                                                       |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

COMMAND OUTPUT
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Security:                                                                                                                                                                                                                                |
| 	Master password revision code = 65534                                                                                                                                                                         |
| 		supported 									                                                                                                                                    |
| 	not.   enabled                                 				                                                                                                                                                 |
| 	not    locked             					                                                                                                                                                             |
| 	not    frozen                                          				                                                                                                                                             |
| 	not	expired: security count                               			                                                                                                                             |
| 		supported: enhanced erase   				                                                                                                                                                   |
| 	2min for SECURITY ERASE UNIT. 2min for ENHANCED SECURITY ERASE UNIT.                                                                                             |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DO THE ABOVE AT YOUR OWN RISK
DO NOT RUN SECURITY ERASE WITHOUT SETTING A PASSWORD
TIME OUT MAY OCCUR ON LARGER HARDRIVES

















##########################################################################################################################################################################################################################################











STAGE TWO
STAGE TWO:
USING DM-CRYPT TO ENCRYPT YOUR HARDDRIVE - ENCRYTPED /BOOT AND A DETACHED LUKS HEADER ON USB PREPARING MAIN DRIVE
	PARTITIONING
		SETTING LOGICAL VOLUME MANAGEMENT
			INITIAL BOOT

SECURE ERASURE OF ENCRYPTED CONTAINER USING CRYPTSETUP
Before beginning it may be prudent to delve into how to securely erase a disk anteceding unencrypted usage of, or without having intially done, the ATA SECURE erasure above. Dm-crypt using the cryptsetup command may be used to perform a secure erasure of the disk with random data. Using ATA SECURE erase alongside dm-crypt random data is just to be thorough. Technically it's possible to recover data from a drive that's been filled with random data or "zero filled", it's just incredibly unlikely. Really it's a matter of preference which option to use and that should come down to the users knowledge of given hardware. The most obvious downside to utilizing the dm-crypt method however is simply the amount of time it takes. Securely erasing a drive using dm-crypt may take several days given multi-terabyte harddrives. Using a 120 GB SSD using dm-crypt takes much longer than using ATA SECURE erase, but even more specific use cases such as over-provisioning or ssd memory cell clearing using hdparm would require ATA Secure erasure. Again, know your hardware and what you as user want do. 

HAJIME
Allot several hours to several days to wipe the disk depending on the size
First you'll need to create an encrypted container. This should be sufficient practice for what comes later. 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cryptsetup -v - -cipher aes-xts-plain64  - -key-size 512 - -hash sha512  - -iter-time 5000   - - use-random  - -verify-passphrase luksFormat  /dev/sda
| # cryptsetup open --type plain -d /dev/urandom /dev/sda wipeme
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
check that the drive actually exist by running command lsblk: list block devices. the blkid command may also be used
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # lsblk
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| NAME 		MAJ:MIN	 RM		SIZE RO	TYPE	MOUNTPOINT
| sda			       8:0          0             1.8T    0      disk
| 			   252:0.         0             1.8T    0     crypt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
that should look something like the desired command output
once done wipe the container with zeroes. 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # dd if=/dev/zero of=/dev/mapper/wipeme status=progress
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| dd: writing to '/dev/mapper/wipeme': No space left on device
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

once that's done close the encrypted container
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cryptsetup close wipeme
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

keep in mind that this process need be performed only once in the entire life time of the drive. The reasoning behind this is that once the drive is encypted again a simple deletion of the header at the start of the drive may be used to render the rest of the encrypted contents as inoperable as they would be if the drive were simply over written with nonsense since without the key to encryption that's essentially the case. The more specific reasoning behind this is that dm-cypt/LUKS contains a header with the cipher and crypt options used, reffering to dm-mod when opening the block-device. After the header file the actual data partition begins. Hence when re-installing on an already randomized drive, or de-commissioning, most cases would simply require wiping the header rather than overwriting the entire drive. This method of simply destroying the header saves time. In addition this may save on write cycles of SSD drives.

using dd with the bs= option, e.g. bs=1M, is frequently used to increase disk throughput of the operation
perform check of operation by zeroing the partition before creating the wipe container. After the wipe command blockdev --getsize64 /dev/mapper/container can be used to get the exact container size as root. Now od can be used to spotcheck whether the wiper overwrote the zeroed sectors e.g 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # od -j containersize - blocksize 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

od in linux is used to convert the content of input indifferent formats with octal format as the defualt format, typically used for debugging Linux scripts.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cryptsetup close wipeme
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

STAGE TWO
USING DM-CRYPT TO ENCRYPT YOUR HARDDRIVE 
PARTITIONING
ENCRYTPED /BOOT AND A DETACHED LUKS HEADER ON USB PREPARING MAIN DRIVE
PREPARING LOGICAL VOLUME MANAGEMENT
—————————————————————————————————————————————————————————
DM CRYPT
dm-crypt is the standard device-mapper encryption function provided by the Linux Kernel. It's utilized against other encryption options by those that would like full control over all aspects of partition and key management. Management of dm-crypt is done using the cryptsetup userspace utility. Implemented as a device mapper target it may be stacked on top of other device mapper transformations. For the sake of this article dm-crypt will be used contextually as LVM on LUKS, Logical Volume Management with Linux Unified Key Setup, with LUKS (default) being one of four device encryption methods next to plain, limited features for loopAES and Truecrypt devices. Where one could use LUKS on LVM in order to maintian LVM's ability to increase or decrease the size of logical volumes and thus have encrypted partitions across multiple harddrives it's best for the purpose of obfuscation to have LVM built within the encrypted LUKS container.  

ENCRYPTED /BOOT AND DETACHED LUKS HEADER
rather than imbedding the header.img and keyfile into the initramfs image this setup will make the system depend on a usb as a key to unlock the drive at boot. This is in place of a scenario where one is dependent on an encrypted keyfile inside the encrypted boot partition. Since the header and keyfile are both included in the initramfs image and the following custom encrypt hook is specifically for usb's by-id, it's required that one have the usb key to boot. What specifically is the reasoning behind this? One would also use a seperate usb for boot to disable tampering with boot conditional files while the system is on, i.e. removing the usb device after the computer has been succesfully loaded. In addition and as well, using a separate usb device may protect against evil-maid-attacks while the system is powered down and left alone. It's essentially a way to further minimize an attack surface both with physical access as well as electronic access, again it's a slightly more complex concept of the key to a lock. 


preparing disk drives

sdb will be assumed to be the USB drive, sda will be assumed to be the main hard drive. Simply pay attention to the by-id values of each drive. The method I use to find by-id values is by running ls with the following options
------------------------------------------------------------------------------------------------------------------------------------
| # ls -l /dev/disk/by-id
——————————————————————————————————————————————————————————

lrwxrwxrwx 1 root root 9     Feb 1 2:40 ata-SanDisk_SSSSSDDDDDDD123123_123123 ->  . . / . ./sda 
lrwxrwxrwx 1 root root 10   Feb 1 2:40 dm-name-f_37 -> . ./. ./dm-0
lrwxrwxrwx 1 root root 10.  Feb 1 2:40 dm-name-exampleoutput -> . . / . . /dm-2
lrwxrwxrwx 1 root root 10.  Feb 1 2:40 dm-name-mvg-home -> . . / . . /dm - 4
lrwxrwxrwx 1 root root 10.  Feb 1 2:40 dm-name-mvg-root -> . . / . . /dm - 3
lrwxrwxrwx 1 root root 10.  Feb 1 2:40 dm-name-mvg-swap -> . . / . . /dm-1

…
------------------------------------------------------------------------------------------------------------------------------------------------------------------------

It's best practice in this case to write needed by-id paths down for later. These will be used in the custom encrypt hook. /dev/disk/usbdrive-part2 
in addition to usbdrive-part2 you'll need the by-id value of the main harddrive which should be under /dev/sda 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # gdisk /dev/sdb                                                                                                                                                                                                             |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Number	Start	(sector)	End (sector)       	Size		         Code	   Name                                                                                                           |
|     1		            2048		1050623	512.0 MiB	 	EF00   EFI System                                                                                                   | 
|     2                  1050623                  1460223    200.0 MiB.           8300    Linux filesystem                                                                                         | 
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

The 512.0 MiB partition of code type EF00 holds the EFI system partition, but that may have been obvious. The EFI system partition is an OS independent partition that acts as the storage place for EFI bootloaders, applications and drivers necessary to be launched by UEFI firmware. 
the second partition is used as an encrypted /boot partition. The boot partition stores the bootloader loads the kernel initramfs and its own configuration files from the /boot directory. Most use cases as of today would involve laptops using a UEFI system. If you're installing an operating system with different bitness than that of the firmware (i.e. 32-bit OS on a machine with 64-bit UEFI, or vice versa) BIOS would be neccesary however the apparent rule of thumb is if it's a PC shipped with Windows XP or earlier it uses BIOS, with Windows 8 or later, UEFI. If it's a MAC it's used UEFI since 2008. Find out if it's UEFI by examining the partition table and figuring whether it's a GPT disk and has an EFI System Partition, if so then it boots in UEFI mode, otherwise it's BIOS mode. For the sake of brevity i'll be covering the UEFI installation mode. BIOS mode is recommmend in the case of running virtual machines, the need to boot a 32-bit os on a 64 bit machine and when a user will be constantly swapping harddrives. Otherwise it's better to go with UEFI. With all of that out of the way it;'s best to format the ESP as FAT32 of at least size 512 MiB. 550 MiB is actually reccomended to avoid MiB/MB confusion and accidentally creating FAT16 although larger sizes are fine. 

PREPARE AND FORMAT YOUR EFI AND BOOT PARTITION
AT THIS STEP DO NOT MOUNT EITHER PARITION

Again after creating the EFI system partition also called (Extensible Firmware Interface) the ESP  you must format it as FAT32
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| mkfs.fat -F32 /dev/sdx1                                                                                                                                                                                                                                                                                                                                                               | 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
within the arch linux guide it states that if the message. WARNING: Not enough clusters for a 32 bit FAT! reduce cluster size with mkfs.fat -s2 -F32 ... or -s1; otherwise the parition may be unreadbale by UEFI. See the mkfs.fat(8) man page for supported cluster sizes

the kernels and initramfs files need to be accesible by the bootloader or the UEFI itself to succefully boot the system. 
to keep the system simple boot loader choice limits the available mount points for EFI system partition
The scenario's within the arch linux guide are between the following options

	mount ESP to /efi and use a boot loader which has a driver for your root file system (eg GRUB, rEFInd)
	mount ESP to /boot. this is the preferred method when directly booting a EFISTUB kernel from UEFI
	on a lenvo x230 laptop I mount the EFI system partition to /efi and use GRUB 
	remember not to mount anything until the upcoming section

PREPARING THE BOOT PARTITION
Here now we prepare the boot partition. This part is actually more fun.
it will be assumed that the usb drive we're using is listed under lsblk as /dev/sdb and we've adhered to the above format making /dev/sdb2 the correct parition for /boot
run the following crypt setup commands

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cryptsetup luksFormat /dev/sdx2                                                                                                                                                                                                                                                            | 
| # cryptsetup open /dev/sdb2 encryptedboot                                                                                                                                                                                                                                               |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

at which point we create a file system on the partition intended for /boot. Any filesystem that can be read by the bootloader is eligible but let's use an ext4 filesystem.
------------------------------------------------------------------------------------------------------------------------------------------------------------
| mfks.ext4 /dev/mapper/encryptedboot                                                                                                                                                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------
make sure to keep the naming the same across every instance of "encryptedboot"
technically you may name your boot partition whatever you want but it's important that you name it something relavant or at least memorable in the case of needing to perform maintenance on the installation. 
As an explanation of the above, you'll notice that the second cryptsetup command differs from th third mkfs.ext4 command in how the user identifies the parition in question. Here's as to why. The cryptsetup command serves within the linx system as a device mapper meaning that it's utilization creates a section within the architecture of the computer that sits above block-device denotation. In more techincal terms may be described in a lot more complicated fashion but let's just say for simplicity that /dev/mapper/encryptedboot is really just a layer above /dev/sdb2. It's mapped onto the target. with that we now treat the cryptsetup container as we would /dev/sdb2 or any other block device layer. /dev/sda /dev/sdb /dev/sda3 /dev/sdb4 and so on. This is important to know as in the occurence one later finds their parition /dev/mapper/whateverinthiscase has disappeared theyll simply have to remember that little fact and reopen it using cryptsetup. Hopefully doing so will give you a better since of how this process functions.

You may pre-prepare by creating the directory /mnt/boot running mkdir but again do not mount /boot
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mkdir /mnt/boot                                                                                                                                                                                                                                                                                                                                                                                                                              |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mount /dev/mapper/encryptedboot /mnt                                                                                                                                                                                                                                                                                                                                                                                          |
| # dd if=/dev/urandom of=/mnt/key.img bs=4M count=1                                                                                                                                                                                                                                                                                                                                                              |
| # cryptsetup --align-payload=1 luksFormat /mnt/key.img                                                                                                                                                                                                                                                                                                                                                       |
| # cryptsetup open /mnt/key.img lukskey                                                                                                                                                                                                                                                                                                                                                                                             |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
the bs option above contains a filesize in bits anteceded by an M suffix. Keep in mind that having too small of a file will get you a "requested offset is beyond real size of device /dev/loop0" error.
as a rough reference creating a 4M file will encrypt it succesffuly. You should make the file larger than the space needed since the encrypted loop device will be a little smaller than the file's size. 
with a large file you may use

--keyfile-offset='offset' as well as keyfile-size='size' to navigate to the correct position but more than likely you'll just need the more simplified command

with that "lukskey" should be opened in a loop device underneath "/dev/loop1" mapped as /dev/mapper/lukskey

PREPARING THE MAIN DRIVE
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # truncate -s 2M /mnt/header.img                                                                                                                                                                                                                                                                                                                                                                                                           |
| # cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset=offset --keyfile-size=size luksFormat /dev/sda --align-payload 4096 --header /mnt/header.img                                                                                                                                                                                                        |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Pick an offet and size in bytes (8192 bytes is the maximum keyfile size for "cryptsetup")
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=offset --keyfile-size=size /dev/sda enc                                                                                                                                                                                                                                           |
| # cryptsetup close lukskey                                                                                                                                                                                                                                                                                                                                                                                                                |
| # umount /mnt                                                                                                                                                                                                                                                                                                                                                                                                                                |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PREPARING LOGICAL VOLUME MANAGEMENT (LVM ON LUKS)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Logical Volume Management uses the Linux kernels device mapper feature providing a system of partitions independent of underlying disk layout. This was mentioned in reference to cryptsetup or LUKS (Linux Unified Key System). What this allows for is the abstraction of storage devices in addition to the creation of virtual partitions. What this may be used for outside the bounds of strict encryption usage is for the extending or shrinking of file systems keeping in mind one is still subject to filesystem limitations. In additional keeping, keep in mind that since the volumes themselves are purely logical one may actually expand volume size over mutiple uncontiguous disk. This would require a LUKS on LVM setup however since the cryptsetup container size itself may not be extended in the same manner as logical volume management. LVM adds no security and it's important to note again the reason behind why you are encrypting your drive. In additional keeping, keep in mind here that your partioning scheme within the logical volume management structure may differ based on the size of your harrdrive. With that here are the listed term definitions of the following commands. 

Physical Volume (PV) 
	The first initiated partition of any aspiring Logical Volume enterprise of a hard disk (or even the disk itself or loopback file) on which you can have volume groups. It has a special header and is divided into physical extents. Think of physical volumes in much the same way one would think 	of building blocks. Here our building blocks are being used to build a harddrive.
Volume Group (VG):
	Group of physical volumes used as storage volumes. Contain lgocial volumes. Think of volume groups as hard drives.
Logical Volume (LV)
	A "virtual logical partition that resides in a volume group and is composed of physcial extents. Think of volume groups as harddrives
Physical Extent (PE)
	The smallest size in the physical volume that can be assigned to a logical volume (default 4 MiB). Think of physical extents as parts of disks that can be allocated to any partition. 

Example of Logical Volume Managment 

Physical Disk 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|							                                                                                                                                                                                                                      |
|	Disk1 (/dev/sda):                                                                                                                                                                                                                                                 |                                
|                                                                                                                                                                                                                                                                                   |
|	-------------------------------------------------------------------------------------------------------------------------------------------------------------                                                      |
|	|	Parition1 50 -120 GiB (Physical Volume).                     | Partition2 80GiB (Physical Volume)                                                   |.                                                       |                                                           
|	|	/dev/sda1								   | /dev/sda2                                                                                              |                                                           |                                                          	-------------------------------------------------------------------------------------------------------------------------------------------------------------                                                              |  	                                                                                                                                                                                                                                                                   |                      
|	Disk2 (/dev/sdb):                                                                                                                                                                                                                                                  |
|                                                                 						                                                                                                                                                                   |               
|              	                                                                                                                                                                                                                                                               |
|	-------------------------------------------------------------------------                                                                                               
|	| Partition1 120 GiB (Physical Volume)				   |                                                                                                                                                                |        
|	| /dev/sdb1					   				   |                                                                                                                                                                         |    
|	-------------------------------------------------------------------------                                                                                                                                                                            |
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                                                                                                                    
|  											                                                                                                                                                                                |
|      LVM logical volume                                                                                                                                                                                                                                              |
|                                                                                                        	                                                                                                                                                                  |
|      Volume Group1                 (/dev/MyVolGroup/ = /dev/sdb1.   +.        /dev/sda2 +.  /dev/sdb1) :                                                                                                                    |
|           ------------------------------------------------------------------------------------------------------------------------------                                                                                          |
|           | Logical volume1 15 GiB                |  Logical volume2 35 GiB       |     Logical volume3 200 GiB            |                                                                                                |
|           | /dev/MyVolGroup/rootvol              |  /dev/MyVolGroup/homevol   |    /dev/MyVolGroup/mediavol         |                                                                                                    |      
|            -----------------------------------------------------------------------------------------------------------------------------                                                                                                |
|												                                                                                                                                                                        |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
As stated in the arch wiki LVM allows one to do a myriad of things lying outside the scope of this article. As touched on above, it's possible to use LVM to use any number of disk as
one large disk but there are a plethora of use cases. 
One may create small logical volumes and resize them dynamically as they get filled. 
Resize logical volumes regardless of their order on disk
Resize/create/delete logical and physical volumes online. 
File Systems on them still need to be resized, but some (ext4) support online resizing.
Online live migration of LV being used by services to different disk without having to restart services. 
Snapshots: probably one of the most important use cases of LVM or the competeing filesystem BTRFS is the ability to snapshot an instance of a distribution as a frozen copy. This helps keep service downtime to a minimum
Support for various device-mapper targets, including transparent filesystem encryption and caching of frequently used data. This allows creating a system with (one or more) physical disks (encrypted with LUKS) and LVM on top to allow for 
easy resizing and management of separate volumes (e.g. for /, /home, /backup etc. without the hassle of entering keys multiple times on boot.) (this statement may contradict the claim that it is not possible to span multiple physical disk with LVM on LUKS.)
Additional steps in settin g up the system, more complicated.


create the pv or physical volume
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # pvcreate /dev/mapper/encryptedmain                                                                                                                                                                                                                                                |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

then create the volume group named MyVolGroup adding the previously created physical volume to it
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # vgcreate mvg /dev/mapper/encrypted                                                                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create all logical volumes on the volume group
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # lvcreate -L 8G MyVolGroup -n swap                                                                                                                                                                                                                                                 |
| # lvcreate -L 32G MyVolGroup -n root                                                                                                                                                                                                                                              |
| # lvcreate -l 100%FREE MyVolGroup -n home                                                                                                                                                                                                                              |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

format filesystems on each logical volume:
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mkfs.ext4 /dev/mvg/root                              	                                                                                                                                                                                                                                   |
| # mkfs.ext4 /dev/mvg/home                                                                                                                                                                                                                                                              |
| # mkswap /dev/mvg/swap                                                                                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

mount each filesystem in kind
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mount /dev/MyVolGroup/root /mnt                                                                                                                                                                                                                                                   |
| # mkdir /mnt/home                                                                                                                                                                                                                                                                             |
| # mount /dev/MyVolGroup/home /mnt/home                                                                                                                                                                                                                                 |
| # swapon /dev/MyVolGroup/swap                                                                                                                                                                                                                                                       |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mkdir /mnt/boot                                                                                                                                                                                                                                                                                 |                                      
| # mkdir /mnt/efi                                                                                                                                                                                                                                                                                 |
| # mount /dev/mapper/encryptedboot /mnt/boot                                                                                                                                                                                                                             |
| # mount /dev/sdb1 /mnt/efi                                                                                                                                                                                                                                                                   |                                         
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PARTITIONING as per the ARCH WIKI 

As far as partitioning goes the root directory is the top of the hierarchy, the point where the primary filesystem is mounted and from which all other filesystems stem. 
All files and directories appear under the root directory /, even if they are stored on different physical devices. 
The contents of the root filesytem must be adequate to boot, restore, recover, and/or repair the system.
Therefore certain directories under / are not candidates for separate partitions. 
The / partition or root parition is necessary and it is the most important. The other paritions can be replaced by it.
/ traditionally contains the /usr directory which can grow significantly depending upon how much software is installed. 
15-20 GiB should be sufficient for most users with modern hard disks. If you plan to store a swap file here, you might need a larger partition size. 
In our case we already have a seperate partition for swap on the same Volume Group of this specific usage of Logical Volume Management.

/boot

the /boot directory contains the kernel and ramdisk images as well as the bootloader configuration file and bootloader stages. 
It also stores data that is used before the kernel begins executing user-space programs. 
/boot is not required for normal system operation, but only during boot and kernel upgrades (when regenerating the initial ramdisk).
As per the above the suggested size for boot is 200 MiB but since we've already allocated space on a seperate usb stick this is redundant information moving on.

	a seperate /boot partition is only needed if your boot loader cannot access your root filesystem. 
	For example, if the boot loader does not have a filesystem driver or if an encrypted volume or a LVM volume
	if booting using UEFI boot loaders not contianing drivers for other file systems err on the side of mounting EFI system partition to /boot
	again the suggested size for /boot is 200 MiB unless your are using EFI system partition as /boot in which case 550 MiB is recommended

/home
	the /home directory contains user-specific configuration files, caches, application data and media files
	Seperating out /home allows / to be re-partitioned separately, but note that you can still reinstall Arch with /home
	untouched even if it is not seperate - the other top-level directories just need to be removed and then padcstrap can be run

	you should not share home directories between user on different distributions because they use incompatiible software versions and patches.
	Instead, consider sharing a media partition or at least using different home directories on the same /home parition. The size of this parition varies. 
	
/var
	the /var directory stores variable data such as spool directories and files, adminstrative and logging data, pacman's cache, the ABS tree, etc. 
	It is used, for example, for aching and loggingl and hence frequently read or written. 
	Keeping it in a separate parition avoids running out disk space due to flunky logs, etc. 
	it exists to make it possible to mount /usr as read-only. Everything that historically went into /usr that is written to during system operation as opposed to installation and software maintenance must reside under /var
	/var will contain, among other data the ABS tree and the pacman cache. Retaining these packages is helpful in case a apckage upgrade causes instability, requiring a downgrade to an older  archived package. 
	the pacman cache in particular will grow as the system is expandedd and updated, but it can be safely cleared if speace becomes an issue. 8-12 GiB on desktop system should be sufficient for /var, depending on how much software will be installed. 

/data
	one can consider maintaining a "data" partition to cover various files to be shared by all users. Using the /home parititon for this purpose is fine as well. The size of this partition varies. 

Swap
	a swap partition provides memory that be used as virtual RAM. A swap file should be considered too, as they do not have any performance overheard compared to a partition but are much easier to resize as needed. 
	A swap parition can potentially be shsared between operating systems, but not if hiberation is used.
	Historically, general rule for swap partition size was to allocate twice the amount of physical RAM. AS computers have gained ever larger memory capacities, this rule is outdated. For example, on average desktop machines with up to 512 MiB RAM,
	the 2 x rule is usually adequate; if a sufficient amount of RAM (more than 1024 MiB) is available it mab be possible to have a smaller swap partition. 

	to use hiberanation (a.k.a suspend to disk) it is advised to create the swpa partition at the size of RAM. Althgouth the kernel will try to compress the suspend to disk image to fit the swap space there is no guranteee it will succeed if the used swap space is significiantly smaller than RAM
	
As far as what partitioning tools to use i'd recommend using gdisk or fdisk and/or simply keeping usage of one or the other consistent across multiple instancies, installations
With that being said it is important to note compatibility to the chosen type of paritition table. Incompaitible tools may result in the destruction of that table, along with existing paritions or data. 
Really though you want to get his correct the first time unless having to resize a volume, that's time and energy saved. Backup either way. 
The last thing to note really is that a user may want to check the alignment of each parition to maximize drive space and keep errors at a minimum of 0. 
One may use gparted to check partitioning alignment

----------------------------------------------------------------------------------------------------------------------------------
| gparted                                                                                                                                                               |
----------------------------------------------------------------------------------------------------------------------------------
| #parted /dev/sda                                                                                                                                                 |                          
| (parted) align-check optimal 1                                                                                                                        |
| 1 aligned                                                                                                                                                       |
----------------------------------------------------------------------------------------------------------------------------------

the mkdir command for /mnt/boot might have already been completed but if not don’t forget to create /boot in addition to /efi.
 As an aside /mnt is the mount directory and is a general use for mount points on the system.
 it's the same directory used when mounting a usb in windows ubuntu or osx distributions. 

ARCH LINUX INSTALLATION
simply follow stated commands below to install a base package of arch linux
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # pacstrap /mnt base                                                                                                                                                                                                                                           |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
installs the base package group via the pacstrap script. It might be advisable to install other such packages as well, a favorite is base-devel, but another is also linux-hardened. 
It's always possible to go back and install these same applications for later.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # genfstab -U /mnt >> /mnt/etc/fstab                                                                                                                                                                                                                 |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
generates an fstab image with -U or -L to define by UUID or labels respectively

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # arch-chroot /mnt                                                                                                                                                                                                                                             |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
changes root into the newly installed system

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # ln -sf /usr/share/zoneinfo/Region/City /etc/localtime                                                                                                                                                                                     |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
sets the time zone. Set your timezone to wherever

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # hwclock --systohc                                                                                                                                                                                                                                            |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

uncomment needed locales in /etc/local.gen and generate them with:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # locale-gen                                                                                                                                                                                                                                                        |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Set the LANG variable in locale.conf accordingly, for example

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # /etc/locale.conf									                                                                                                                                                              |
|                                                                                                                                                                                                                                                                              |
|                                                                                                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|# LANG=en_US.UTF-8 							                                                                                                                                                                      |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # /etc/vconsole.conf               	                                                                                                                                                                                                                      |
|   				                                                                                                                                                                                                                                        |
|			                                                                                                                                                                                                                                                 |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|KEYMAP=de-latin1                                                                                                                                                                                                                                             |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
|Create the hostname file                                                                                                                                                                                                                                     |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # /etc/hostname                                                                                                                                                                                                                                              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # myhostname                                                                                                                                                                                                                                                    |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| Add matching entries to hosts (5)                                                                                                                                                                                                                        |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # /etc/hosts                                                                                                                                                                                                                                                           |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| 127.0.0.1			localhost						                                                                                                                                                                     |
| : :1				localhost	 		          	                                                                                                                                                                            |                      
| 127.0.1.1			myhostname.localdomain myhostname                                                                                                                                                                         |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
(some of the lines make text emoji sleeping faces. I did that just for you)

Normally during this step in the installation process you'd complete the mkinitcpio step, skipping partitioning formatting and mounting of drives. 
Instead of simply directly running mkinitcpio, as in a normal installation, the user must first create a custom encrypt hook. 
This hook follows persistent block device naming by-id and by-path to figure out by-id values for the usb and main hard drive
these id values are linked to sda or sdb respectively
by id is used rather than simply denoting sda or sdb within the customencrypt hook as, again, the values for sda or sdb may change. 
This ensures the correct device is enabled
one may name the customencrypt hook anything they want and custom build hooks may be placed in the hooks and install folder of /etc/initcpio
keep a backup of both files (cp them over to the /home parition or your user's /home directory after making one).
/usr/bin/ash is not a typo


MKINITCPIO: CREATING A CUSTOM ENCRYPT HOOK
mkinitcpio is a bash script used to create an initial ramdisk environment, an environment for loading a temporary root file system into memory, 
an environment which may be used as part of the linux startup process. initrd and initramfs refer to two different methods of archieving this. 
both are commonly used to make preparations before the real root file system can be mounted. 
This is done in order to decrease kernel size and avoid having to hardcode handling for different use cases into the kernel, an initial boot stage with a temporary root-file system.
Dubbed early user space, this temporary root file system contains user-space helpers which do the hardware detection module loading and device discovery necessary to get the real root file-system mounted

From the arch wiki: 

		The initial ramdisk is in essence a very small environment (early userspace) which loads various kernel modules and sets up necessary things before handing over control to init. 
		This makes it possible to have, for example, encrypted root file sytems and root file systems on a software RAID array.
		Mkinitcipio allows for easy extension with custom hooks, has auto-detection at runtime and many other features. 

MKINITCPIO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| /etc/initcpio/hooks/customencrypthook                                                                                                                                                                                                          |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| #!/usr/bin/ash              			                                                                                                                                                                                            |
|         			                   	                                                                                                                                                                                                       |
| run_hook( ) {    					                                                                                                                                                                                                  |  
| modprobe -a -q dm-crypt >/dev/null                                                                                                                                                                                                             |
| 2>&1                                                                                                                                                                                                                                                   |
| modprobe loop                                                                                                                                                                                                                                               |
| [ "${quiet}" = "y" ] &&                                                                                                                                                                                                                            |    
| CSQUIET=">/dev/null"                                                                                                                                                                                                                                |
|                                                                                                                                                                                                                                                              |
| while [ ! -L '/dev/disk/by-id/usbdrive-part2' ]; do                                                                                                                                                                                         |
| echo 'Waiting for USB'                                                                                                                                                                                                                             |
| sleep 1                                                                                                                                                                                                                                                           |
| done                                                                                                                                                                                                                                                     |
|                                                                                                                                                                                                                                                                       |
| cryptsetup open /dev/disk/by-id/usbdrive-part2 cryptboot                                                                                                                                                                       |
| mkdir -p /mnt                                                                                                                                                                                                                                                |
| mount /dev/mapper/cryptboot /mnt                                                                                                                                                                                                     |
| cryptsetup open /mnt/key.img lukskey                                                                                                                                                                                                         |
| cryptsetup --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=''offset'' --keyfile-size=''size'' open /dev/disk/by-id/harddrive enc             |
| cryptsetup close lukskey                                                                                                                                                                                                                               |
| umount /mnt                                                                                                                                                                                                                                         |
| }                                                                                                                                                                                                                                                                    |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
replace all within quotations using the values user originally specified during implementation of the documentation above.
afterwards copy the newly created customencrypthook to the correct directory using the cp command

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # cp /usr/lib/initcpio/install/encrypt  /etc/initcpio/install/customencrypthook                                                                                                                                                   |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

After copying edit the file and remove the help( ) section as it is not neccesary
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| /etc/mkinitcpio.conf                                                                                                                                                                                                                                            |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MODULES=(loop)
...
HOOKS=(base udev autodetect modconf block customencrypthook lvm2 filesystems keyboard fsck)



Generate a initramfs file
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # mkinitcpio -p linux                                                                                                                                                                                                                                           |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Set a route password
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # passwd                                                                                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # pacman -S grub efibootmgr                                                                                                                                                                                                                              |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB                                                                                                                                                                         |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
install grub

edit /etc/defautl/grub
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # nano /etc/default/grub         									|
|														|
|	/etc/default/grub										   |
|													   |
|	GRUB_ENABLE_CRYPTODISK=y					     		|
|														|
|	/etc/default/grub											|
|														|
|	GRUB_PRELOAD_MODULES="... lvm"						|
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
edit /etc/defautl/grub

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # grub-mkconfig -o /boot/grub/grub.cfg                                                                                                                                                                                                                                                                                                                                                                                         |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
make and configure grub

MAINTENANCE INSTRUCTIONS
to perform maintenance boot into a live installation disk again and run the following commands as they pertain to your drive. 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# cryptsetup open /dev/sdb2 encryptedboot                                                                                                                                                                                                                                                                                                                                                                                    |
# mount /dev/mapper/encryptedboot /mnt                                                                                                                                                                                                                                                                                                                                                                                    |
# cryptsetup open /mnt/key.img lukskey                                                                                                                                                                                                                                                                                                                                                                                   |
# cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=offset --keyfile-size=size /dev/sda encrypted                                                                                                                                                                                                                             |
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
this should allow you access to the freshly installed arch linux distro to fix whatever problems that might need correcting without having to redo the entire installation. 
















##########################################################################################################################################################################################################################################














STAGE THREE:
STAGE THREE:
SETTING USER ACCESS AND SECURITY
SETTING GRAPHICAL USER INTERFACE
SETTING VIRTUAL TESTING ENVIRONMENT 
	SETTING SELINUX WITHIN VIRTUAL ENVIRONMENT

VAGRANT
Vagrant is a tool for managing and oniguring virtualized development environments.
Vagrant has a conept of providers, providors map the the virtualization engine and its API.
Of course Virtualbox is the most popular and well supported provider. plugins exist for libvirt, kvm, lxc, vmware and more.
Vagrant uses a mostly decalrative Vagrantfile to define virtualised machines. 
A single Vagrantfile can define multiple machines.

VIRTUAL BOX 
As per the arch wiki virutal box is a hypervisor used to run operating systems in a special environment called a virtual machine on top of the existing operating system. 
Virtual box is in constant development and new features are implemented continuously.
 For further definition here, a hypervisor is any computer software firmware or hardware that creates and runs vitual machines.
A virtual machine in and of itself, in it's simplest terms, is just an emulation of a computer system. The implementations may involve specialized hardwarea software or a combination. 

To install vagrant use the vagrant package from the official repository using the package manager. 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S vagrant 			                                                                                                                                                                                                                                     |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 install virtualbox 
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S virtualbox 			                                                                                                                                                                                                                                     |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in addition to installing the base virtualbox packages its also neccesary to install packages to provide host modules within Virtualbox
for the linux kernel choose virtualbox-host-modules-arch

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S virtualbox-host-modules-arch 			                                                                                                                                                                                               |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for other kernels choose virtualbox-host-dkms

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S virtualbox-host-dkms 			                                                                                                                                                                                                                  |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
it's best to go with both for future usage or just where neccesary but dkms virtualbox-host-dkms may actually be all you need.
in addition it's necessary to install the appropriate headers package(s) for your installed kernel(s):
linux-headers or linux-lts-headers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S linux-headers 			                                                                                                                                                                                                                           |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # sudo pacman -S linux-lts-headers 			                                                                                                                                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
when either VirtualBox or the kernel is updated
the kernel modules will be automatically recompiled thanks to the DKMS pacman hook

To directly provision a virtual machine using Vagrant and SELinux run the following
First its neccesary to add a base arch linux distribution to Vagrant
this isnt all too difficult however it may or may not take some time depending on internet connectivity. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # vagrant box add terrywang/archlinux                                                                                                                                                                                                                                      |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
the above command is missing the --name parameter in between add and terrywang/archlinux
keeping that portion of the command may throw an error however. 
I found it best to simply leave out --name, however this may be a misunderstanding of syntax on my part. 
Check vagrant command options via "vagrant -h"
in order to check the above command functioned properly one may list installed vagrant boxes. Run the following
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # vagrant box list                                                                                                                                                                                                                                                                        |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
the return output on the command line should be the installed arch linux kernel
Next run
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| git clone https://github.com/archlinuxhardened/selinux                                                                                                                                                                                                         |
| cd selinux/_vagrant                                                                                                                                                                                                                                                                     |
| rm Vagrantfile                                                                                                                                                                                                                                                                         |
| vagrant init terrywang/archlinux                                                                                                                                                                                                                                               |
| vagrant up                                                                                                                                                                                                                                                                                    |
| vagrant ssh                                                                                                                                                                                                                                                                                |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

After removing the original Vagrant file and running the command "vagrant init terrywang/archlinux" it's neccesary to use the text editor of your choice in order to change the 
"machine.vm.box = " configuration setting
where originally the setting should be set to machine.vm.box = "archlinux"
configuration setting should now be changed to 
machine.vm.box = "terrywang/archlinux"


the above should be all that's neccesary to have virtual box alongside vagrant properly installed on your host machine. 
where neccesary it may be required to further tune laptop virtualization settings in order to make sure the process is allowed to run properly run. 
Check your BIOS settings in addition to running package managers update configuration using pacman -Syu in order to ensure installed packages are up to date. 
Troubleshoot as neccesary. 

SETTING SELINUX
for greater kernel security we'll use SELINUX, a linux kernel module developed by the NSA for replacement of the stock linux-kernels Discretionary Access Control (DAC) with Mandatory Access Control (MAC).
The simplest way to explain DAC vs MAC is predicated on describing the definition of discretionary access control DAC. 
Discretionary Access Control is defined by the Trusted Computer System Evaluation Criteria as a means of restricting access to objects based on the identity of subjects and/or groups to which they belong.
The controls are discretionary in the the sense that a subject with a certain access permission is capable of passing that permission (perhaps indirectly) on to any other subject. 
This is the case if Discretionary Access Control is left unconstrained by mandatory access control.
A system may be purely based on Discretionary Access Control, a combination of Mandatory Access Control, or Mandatory Access Control alone. 
The most important distinction to note between the two is that MAC is centrally controlled by a security policy administrator, users do not have the ability to overwrite permission policy
Also an important distinction to note is MAC's access control policy uses a subject object relationship between processes or threads where processes and threads act as subject and files act as object. 
In addition to that a database management system in its access control mechanism can also apply mandatory access control
Here the objects are tables, views, procedures, etc. 
If one wanted to delve deeper into what constitutes robustness as far as mandatory access controls the CSC-STD-004-35 gives exact degrees on a quantifiable scale. 
The two compenents of robustness as far as the CSC-STD-004-35 goes are Assurance Level and Functionality. 

There are two methods to install the requisite SELinux packages.

VIA AUR per the ARCH LINUX WIKI
first install the SElinux userspace tools and libraries, in this order (because of the dependencies): libsepool , libselinux, secilc, checkpolicy, setools, libsemanage, semodule-utils, policycoreutils, selinux-python (which depends on pyton-ipy), mcstrans and restoresecond.
Then install pambase-selinux and pam-selinux and make sure you can login again after the installation completed, necause files in /etc/pam.d/ got removed and created when pambase got replaced with pambase-selinux.
Next recomplile some core packages by installing coreutilsp-selinux, findutils-selinux, iproute2-selinux, logrotate-selinux, openssh-selinux, psmisc-selinux, shadow-selinux, cronie-selinux
Next backup you /etc/sudoers file. Install sudo-selinux and restore your /etc/sudoers (it is overidden wihen this package is installed as a replacment of sudo).
Next comes util-linux and systemd. 
Due to cyclic makedepends between these two packages which will not be fixed, 
you need to build the source package systemd-selinux install libsystemd-selinux build and install util-linux-selinux with libutil-linux-selinux and rebuild and install sytemd-selinux
next install dbus-selinux
next install selinux-alpm-hook in order to run restorecon every time pacman installs a package. 

AFTER ALL THESE STEPS YOU CAN INSTALL AN SELINUX KERNEL (like linux-selinux) and a policy like selinux-refpolicy-arch selinux-refpolicy-git).

Using the GITHUB REPOSITORY

All packages are maintained at https//guthub.com/archlinuxhardened/selinux. This repository also contains a script named build_and_install_all.sh
which builds and installs (or updates) all packages in the needed order. Here is an example of a way this script can be used in a user shell to install all packages (with downloading the GPG keys which are used to verify the source tarballs of the package. 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| git clone https://github.com/archlinuxhardened/selinux                                                                                                                                                                                                         |
| cd selinux                                                                                                                                                                                                                                                                           |
| ./recv_gpg_keys.sh                                                                                                                                                                                                                                                                     |
| ./build_and_install_all.sh                                                                                                                                                                                                                                                      |
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CHANGING BOOTLOADER CONFIGURATION
after intallation of a new kernel it's neccesary to update the bootloader configuration accordingly. Moreover you need to add secuirty=selinux selinux=1 to the kernel command line.
More precisely if the kernel configuration does not set CONFIG DEFAULT_SECURITY_SELINUX, security=selinux is needed
if it contains CONFIG_SECURITUY_SELINUX BOOTPARAM=y CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=0 , selinux=1 is needed

GRUB
Add security=selinux selinux=1 to GRUB_CMDLINE_LINUX_DEFAULT variable in /etc/default/grub. 
Run the following command:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # grub-mkconfig -o /boot/grub/grub.cfg                                                                                                                                                                                                                                       |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Syslinux: a colection of bootloaders capable of booting from drives, CD's abnd over the network via PXE.
suported filesystems are FAT, ext2, ext3, ext4 and uncompressed single-device Btrfs

change your syslinux.cfg file by adding:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| /boot/syslinux/syslinux.cfg                                                                                                                                                                                                                                                         |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| LABEL arch-selinux                                                                                                                                                                                                                                                                   |
|		LINUX ../vmlinuz-linux-selinux                                                                                                                                                                                                                           |
|		APPEND root=/dev/sda12 ro security=selinux selinux=1                                                                                                                                                                              |
|		INITRD ../initramfs-linux-selinux.img                                                                                                                                                                                                               |
|                        (change the above portion "at the end" to whatever kernel version you're using)                                                                                                                                              |      
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CHECKING PAM
It's important for a user to set up a correct usage of PAM in order to recieve the proper security context after login.
To do so it's important to check for he presence of the following lines in /etc/pam.d/system-login:
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # pam_selinux.so close should be the first session rule                                                                                                                                                                                         |
| session		required		pam_selinux.so close                                                                                                                                                                                          |
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # pam_selinux.so open sould only be folowed bby session to be executed in the user context                                                                                                                            |
| session		required		pam_selinux.so open		                                                                                                                                                                             |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

INSTALLING A POLICY
Since using the SElinux linux security module it's obviously important to set a policy, what governs SELinux's behavoir. The only policy currently available in the AUR is the reference policy. 
In order to install it, you should use the source files from the package selinux-refpolicy-src or by downloading the latest releases on 
http://github.com/TresysTechnology/refpolicy/wiki/DownloadRelease#current-release
When using the AUR package navigate to /etc/selinux/refpolicy/src/policy
run the following commands

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # make bare			                                                                                                                                                                                                                                              |
| # make conf                                                                                                                                                                                                                                                               |
| # make install							                                                                                                                                                                                               |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

the above installs the reference policy as it is.
of course it's possible to tweak the selinux policy accordingly to administrator/user needs 
at the same time it's good to note that SElinux policies are generally extremely customizable and may take quite a while to fully master a given policy just like anything else worth doing.
The above command takes a while, taking a core of a processor to complete.
Again, wait.

Once that's finished load the reference policy

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # make load                                                                                                                                                                                                                                                          |                                
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Then, make the file /etc/selinux/config with the following contents 
presuming you've chosen to use the default refference policy. (no name change)

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| /etc/selinux/config                       	                                                                                                                                                                                                                          |
—————————————————————————————————————————————————————————————————————
| # This file controls the state of SELinux on the system.                                                                                                                                                                                         |
| # SElinux= can take one of these three values:                                                                                                                                                                                                   |
| # 		enforcing   -   SElLinux secuirty policy is enforced                                                                                                                                                                    |
| #				    Set this value once you know for sure that SElinux is configured the way you like it and that oyur system is ready for deployment                      |
| #               permissive -   SElinux prints warnings instead of enforcing.                                                                                                                                                     |
| #                                      Use this to cutomize your SELinux policies and booleans prior to deployment. Recommend during policy development                                      |
| #               disabled.    -   No SELinux policy is loaded.                                                                                                                                                                                          |
| #                                      This is bnot a recommended setting, for it may cause probnlems with file labelling.                                                                                               |
| #                                                                                                                                                                                                                                                                   |
| # SELINUX = permissive                                                                                                                                                                                                                                       |
| # SELINUXTYPE = takes the name of SELinux policy to                                                                                                                                                                              |
| # be used. Current options are:                                                                                                                                                                                                                   |
| #		refpolicy (vanilla reference policy)                                                                                                                                                                                                       |
| #               < custompolicy > - Substitute < custompolicy > with the name of aqny custom policy you choose to load                                                                                 |
| # SELINUXTYPE=refpolcy                                                                                                                                                                                                                      |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

After completeing a correct reference policy implementation it's neccesary to reboot
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # restorecon -r /                                                                                                                                                                                                                                                              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

to label your filesystem
make a file requiremod.te with the contents:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| requiremod.te                                                                                                                                                                                                                                                              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------                                                                                                                                                                               
| module requiremod 1.0;                                                                                                                                                                                                                                             |
|                                                                                                                                                                                                                                                                                   |
| reqiure {                                                                                                                                                                                                                                                                 |
|              type devpts_t;                                                                                                                                                                                                                                        |
|	     type  kernel_t;                                                                                                                                                                                                                                           |
|              type device_t;                                                                                                                                                                                                                                              |
|              type var_run_t;                                                                                                                                                                                                                                             |
|              type udev_t;                                                                                                                                                                                                                                               |    
|              type hugetlbfs_t;                                                                                                                                                                                                                                      |
|              type udev_tbl_t;                                                                                                                                                                                                                                    |
|              type tmpfs_t;                                                                                                                                                                                                                                              |
|              class sock_file write;                                                                                                                                                                                                                               |
|              class unix_stream_socket { read write ioctl };                                                                                                                                                                                             |
|              class capability2 block_suspend;                                                                                                                                                                                                             |
|              class dir { write add_name };                                                                                                                                                                                                            |
|              class filesystem associate;                                                                                                                                                                                                                      |
| }                                                                                                                                                                                                                                                                               |
|  ============ devpts_t ============                                                                                                                                                                                                     |
| allow devpts_t device_t:filesystem associate;                                                                                                                                                                                                        |
|                         										                                                                                                                                                            |
|  ============ hugetlbfs_t ============				                                                                                                                                                        |
| allow hugetlbfs_t device_t:filesystem associate;                                                                                                                                                                                               |
|  										                                                                                                                                                                          |
|  =========== kernel_t ==============					                                                                                                                                                                | 
| alllow kernel_t self:capability2 block_suspend;			                                                                                                                                                                      |
|                                                                                                                                                                                                                                                                       |  
| ============ tmpfs_t ================                                                                                                                                                                                                  |
| allow tmpfs_t device_t:filesystem associate;                                                                                                                                                                                                     |
|                                                                                                                                                                                                                                                                       |
| ============ udev_t =================                                                                                                                                                                                                   |
| allow udev_t kernel_t:unix_stream_socket { read write ioctl }                                                                                                                                                                         |
| allow udev_t udev_tbl_t:dir { write add_name };                                                                                                                                                                                        |
| allow udev_t var_run_t:sock_file write;                                                                                                                                                                                                             |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in addition run the following commands:
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # checkmodule -m -o requiredmod.mod requiremod.te                                                                                                                                                                                        |
| # semodule_package -o requiredmod.p -m requiredmod.mod                                                                                                                                                                                |
| # semodule -i requiredmod.pp                                                                                                                                                                                                                             |
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

POST INSTALLATION STEPS
once installed check that SElinux is working with sestatus. The following is example output
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| SELinux status:				enabled                                                                                                                                                                                                                |
| SELinux mount:			/sys/fs/selinux                                                                                                                                                                                                 |
| SELinux root directory:		/etc/selinux                                                                                                                                                                                                        |
| Loaded policy name:			refpolicy                                                                                                                                                                                                              |
| Current mode:				permissive                                                                                                                                                                                                        |
| Mode from config file:		permissive                                                                                                                                                                                                     |
| Policy MLS status:			disabled                                                                                                                                                                                                               |
| Policy deny_unknown status:        allowed                                                                                                                                                                                                            |
|Max kernel policy version:		28                                                                                                                                                                                                                 |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

To maintain correct context, you can use restorecond:
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| # systemctl enable restorecond 	 				                                                                                                                                                                                        | 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

To switch to enforcing mode without rebooting, you can use:
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
| echo 1 > /sys/fs/selinux/enforce	                                                                                                                                                                                                                              |
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REASONING
since SELinux uses mandatory access control and is in general more complicated and thus more supscetible to points of failure, it's thus a good idea to try out either
installing a base SELinux installation in a virtual environment or
or try a more complicated approach of customizing policy rules for mandatory access control while within a virtual environment. 
Either way it's a win. 

SETTING FIREJAIL 
Firejail is an easy to use SUID sandbox program that reduces the risk of security breaches by restricting the running environment of untrusted applciation using linux namespaces, seccomp-bpf and Linux capabilities. 
It's defaul configuration is said to be useful enough however it may be noted that Firejail may be used along side Apparmour, another linux security module that works using path based mandatory access controls rather than file based. 
——————————————————————————————————————————————————————————————————————————
| sudo pacman -S firejail	                                                                                                                                                                                                                                                        | 
——————————————————————————————————————————————————————————————————————————

# rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /path/to/backup/folder

