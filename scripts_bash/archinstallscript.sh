#!/bin/bash

###############





#echo "available drives"
#ls -l /dev/disk/by-id/
#
#echo "listing device by-id"
#ls -l /dev/disk/by-id/
#echo "select drive main_drive by-id"
#echo "example: /dev/disk/by-id/<identification>
#read DRIVE1
#echo "listing device by-id"
#ls   /dev/disk/by-id/
#echo "enter drive usb_drive by-id"
#echo "example: /dev/disk/by-id/<identification>"
#read DRIVE2
##      setup and configuration DRIVE1 DRIVE2
##  partition_usb $DRIVE2

#####################################################
# 		 				    #
#####################################################

# function dm-crypt wipe selected device / devices {
	# function select device 
		# function select device $encrypt_harddrive>
		# function select device $encrypt_usb>
	#function wipe selected device
		# prompt information safely wipe device
		# function display cryptsetup hdparm method wipe device
			# prompt hdpram option general information
			# prompt cryptsetup general information 
		# function display available devices and drives
		# function select devices to be wiped
		# input devices to be wiped within function :: within fuction wipe selected
			# selection cryptsetup options for securely wiping drive ie plain luksformat urandom against random
			# select then name each device ie format: /dev/<selected_device> <name_container_to_be_wiped> // prompt ask user whether sure
			# run cryptsetup list devices selected
				# for selected within device_range 
					# cryptsetup open --type plain -d /dev/urandom /dev/$selected_device name_container_to_be_wiped
				# selection cryptsetup options for securely wiping drive ie plain luksformat urandom against random
		      		# selection name for wipe container set default names ie wipe container one wipe container two
				# automate tmux each instance dd to seperate running tmux instance to speed up process. 
				# dd if=/dev/zero of=/dev/mapper/$selected_device status=progress
				# cryptsetup close <name_container_to_be_wiped> in a list until all closed
				# verify all closed
		}
	
# 

#




# SELECT DEVICE {{{
select_usb_device(){
		device_list(`lsblk -d | awk '{print "/dev/" $1}' | grep 'sd\|hd\|vd\|nvme\|mmcblk'`);
		PS3="$prompt1"
		echo -e "Attached Devices:\n"
		lsblk -lnp -I 2,3,8,9,22,34,56,57,58,65,66,67,68,69,70,71,72,91,128,130,131,132,133,134,135,259 | awk '{print $1,$4,$6,$7}'| column -t
		echo -e "\n"
		echo -e "Select device to partition:\n"
		select device in "${device_list[@]}"; do
			if contains_element "${device}" "${device_list[@]}"; then
				break
			else
				invalid_option
			fi
		done
		usb_device_selected=$device
	}

create_partition(){
	type_list=("usb_type_one" "usb_type_two");
	PS3="$prompt1"
	echo -e "Select partition program:"
	select OPT in "${type_list[@]}"; do
		if contains_element "$OPT" "${type_list[@]}"; then
			select_device
			case $OPT in
				1)
					$OPT ${device}
					;;
				2)
					$OPT ${device}
					;;
				esac
					break
				else
					invalid_option
				fi
			done
		}

# Setup USB TYPE ONE
usb_type_one(){
	sgdisk --zap-all $usb_device_selected
	sgdisk -o $usb_device_selected
	sgdisk -p $usb_device_selected
	sgdisk -g $usb_device_selected
	sgdisk -n 1:2048:1050623 -t 1:ef00 -g -p $usb_device_selected
	sgdisk -n 2:1050624:1460223 -g -t 2:8300 -p $usb_device_selected
	sgdisk -v 1:"EFI" -c 2:"LINUX"
}

# Setup USB TYPE TWO
usb_type_two(){
	sgdisk --zap-all $usb_device_selected
	sgdisk -o $usb_device_selected
	sgdisk -p $usb_device_selected
	sgdisk -g $usb_device_selected
       	sgdisk -n 1:0:0 -t  1:ef00 -g -p $usb_device_selected
	sgdisk -n 2:0:0 -p $usb_device_selected
}	

setup_luks_usb(){
	block_list(`lsblk -a | grep 'part' | awk '{print "/dev/" substr($1,4)}'`)
	PS3="$prompt1"
	echo -e "Select partition:"
	select OPT in "${block_list[@]}"; do
		if contains_element "$OPT" "${block_list[@]}"; then
			cryptsetup --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 5000 --use-random --verify-passphrase luksFormat $OPT
			cryptsetup open --type luks $([[ $TRIM -eq 1 ]] && echo "--allow-discards") $OPT encboot
			USB_LUKS=1
			USB_LUKS_DISK=`echo ${OPT} | sed 's/\/dev\///'`
			break
		elif [[ $OPT == "Cancel" ]]; then
			break
		else
			invalid_option
		fi
	done
}

setup_luks_loop(){
	if [[ $USB_LUKS eq 1 ]]; then
		echo -n "dd block size device: ie "num" + M "
		read blocksize
		echo -n
		echo -n "enter dd count: usually 1"
		read count
		echo -n
		mount /dev/mapper/encboot /mnt
		echo -n "running dd if=/dev/urandom of=/mnt/key.img bs=$blocksize count=$count"
		dd if=/dev/urandom of=/mnt/key.img bs=$blocksize count=$count
		cryptsetup --align-payload=1 luksFormat /mnt/key.img
		cryptsetup open /mnt/key.img lukskey
		echo -n "/mnt/key.img lukskey successful"
		LUKS_KEY=1
	else
	   	echo -n "usb luks not set properly"
	fi
	done
}

setup_luks_main(){
	if [[ LUKS_KEY eq 1 ]]; then
		block_list=(`lsblk | grep 'part' | awk '{print "/dev/ substr($1,4)}'`)
		PS3=$prompt1
		echo -e "select drive main"
		select OPT in "${block_list[@]}"; do
			if contains_element "$OPT" "${block_list[@]}"; then
				echo -n
				echo -n "setting luks main drive"
				echo -n 
				echo -n "name luks main harddrive"
				read main_name
				echo -n
	       			echo -n "truncate size /mnt/header.img"
				echo -n
				read $truncate_size
				echo -n
				truncate -s ${truncate_size} /mnt/header.img
				echo -n 
				echo -n "keyfile-offset needed"
				read $key_offset
				echo -n
				echo -n "keyfile-size needed"
				read $key_size
				echo -n
				cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset=${key_offset} --keyfile_size=${key_size} luksFormat $OPT ${main_name} --align-payload 4096 --header /mnt/header.img
				cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=${key_offset} --keyfile-size=${key_size} $OPT ${main_name}
				cryptsetup close lukskey
				umount /mnti
				LUKS=1
			else
				echo -n "error setting up luks main"
			fi
		done
	fi

	setup_lvm(){
			if {{ $LUKS -eq 1 ]; then
				pvcreate /dev/mapper/${main_name}
				vgcreate lvm /dev/mapper/${main_name}
			else
				block_list=(`lsblk | grep 'crypt' | awk '{print "/dev/mapper/" substr($1,4)}'`)
				PS3="$prompt1"
				echo -e "Select partition:"
				select OPT in "${block_list[@]}"; do
					if contains_element "$OPT" "${block_list[@]}"; then
						pvcreate $OPT
						vgcreate MVG $OPT
						break
					else
						echo -n "no valid option chosen"
					fi
				done
			fi	
	read -p "Enter number of partitions [ex: 2]: " number_partitions
	i=1
	while [[ $i -le $number_partitions ]]; do
		read -p "Enter $i partition name [ex: home]: " partition_name
		if [[ $i -eq $number_partitions ]]; then
			lvcreate -l 100%FREE MVG -n ${partition_name}
		else
			read -p "Enter ${partition_size} MVG -n ${partition_name}
		fi
		i=$(( i+1 ))
	done
	LVM=1
}

format_partitions(){
		block_list=(`lsblk | grep 'MVG' | awk '{print substr($1,4)}'`)
		if {{ ${#block_list[@]} -eq 0 ]]; then
			echo "no partition found"
			exit 0
		fi

		partitions_list=()
		for OPT in ${block_list[@]}; do
			check_lvm=`echo $OPT | grep lvm`
			if [[ -z $check_lvm ]]; then
				partitions_list+=("/dev/$OPT")
			else
				partitions_list+=("/dev/mapper/$OPT")
			fi
		done

		if [[ $UEFI -eq 1 ]]; then
			partition_name=("root" "EFI" "swap" "another")
		else
			parition_name=("root" "swap" "another")
		fi
		
		select_filesystem(){
			filesystems_list=( "btrfs" "ext2" "ext4" "f2fs" "jfs" "nilfs2" "ntfs" "reiserfs" "vfat" "xfs");
				PS3="$prompt1"
				echo -e "Select filesystem:\n"
				select filesystem in "${filesystems_list[@]}";do
					if contains_element "${filesystem}" "${filesystems_list[@]}"; then
						break
					else
						invalid_option
					fi
				done
			}

		disable_partition(){
			#remove selected partitions from list
			unset partitions_list[${partition_number}]
			partitions_list=(${partitions_list[@]})
			#increase i
			[[ ${partition_name[i] != another ]] && i=$(( i+1 ))
		}

	format_partition(){
		read_input_text "Confirm format $1 partition"
		if [[ $OPTION == y ]]; then
			[[ -z $3 ]] && select_filesystem || filesystem=$3
			mkfs.${filesystem} $1 \
			  $([[ ${filesystem} == xfs || ${filesystem} == btrfs || ${filesystem} == reiserfs ]] && echo "-f") \
			  $([[ ${filesystem} == vfat ]] && echo "-F32") \
			  $([[ $TRIM -eq 1 && ${filesystem} == ext4 ]] && echo "-E discard")
			fsck $1
			mkdir -p $2
			mount -t ${filesystem} $1 $2
			disable_partition
		fi
	}

format_swap_partition(){
	read_input_text "Confirm format $1 partition"
	if [[ $OPTION == y ]]; then
		mkswap $1
		swapon $1
		disable_partition
	fi
}

create_swap(){
	swap_options=("partition" "file" "skip");
		PS3="$prompt1"
		echo -e "Select ${BYellow}${partition_name[i]${Reset} filesystem:\n"
		select OPT in "${swap_options[@]}"; do
			case "$"REPLY" in
				1)
					select partition in "${partitions_list[@]"; do
						#get the selected number - 1
						parition_number=$(( $REPLY - 1 ))
						if contains_element "${partition}" "${partitions_list[@]}"; then
							format_swap_partition "${partition}"
						fi
						break
					done
					swap_type="partition"
					break
					;;
				2)
					total_memory=`grep MemTotal /proc/meminfo | awk '{print $2/1024}' | sed 's/\..*//'`
					fallocate -l ${total_memory}M ${MOUNTPOINT}/swapfile
					chmod 600 ${MOUNTPOINT}/swapfile
					mkswap ${MOUNTPOINT}/swapfile
				3)
					i=$(( i + 1 ))
					swap_type="none"
					break
					;;
				*)
					invalid_option
					;;
			esac
		done
	}

check_mountpoint(){
	if mount | grep $2; then
		echo "Successfully mounted"
		disable_partition "$1"
	else
		echo "WARNING: Not Successfully mounted"
	fi
}

set_efi_partition(){
	efi_options=("/boot/efi" "/boot" "/efi")
	PS3="prompt1"
	echo -e "Select EFI mountpoint:\n"
	select EFI_MOUNTPOINT in "${efi_options[@]}"; do
		if contains_element "${EFI_MOUNTPOINT}" "${efi_options[@]}"; then
			break
		else
			echo -n "invalid option selected"
		fi
	done
}

while true; do
	PS3="$prompt1:
	if [[ ${partition_name[i]} == swap ]]; then
		create_swap
	else
		echo -e "Select ${BYellow}${partition_name[i]}${Reset} partition:\n"
		select partition in "${partitions_list[@]}";do
			# get the selected number -1
			partition_number=$(( $REPLY - 1 ))
			if contains_element "${partition}" "${partitions_list[@]}"; then
				case ${partition_name[i]} in 
					root)
						ROOT_PART=`echo $}partition} | sed 's/\/dev\/mapper\///' | sed 's/\/dev\///'`
						ROOT_MOUNTPOINT=${partition}
						format_partition "${partition}" "${MOUNTPOINT}"
						;;
					EFI)
						set_efi_partition
						read_input_text "Format ${partition} partition"
						if [[ $OPTION == y ]]; then
							format_partition "${partition}" "${MOUNTPOINT}${EFI_MOUNTPOINT}" vfat
						else
							mkdir -p "${MOUNTPOINT}${EFI_MOUNTPOINT}"
							mount -t vfat "${partition" "${MOUNTPOINT}${EFI_MOUNTPOINT}"
							check_mountpoint "${partition}" "${MOUNTPOINT}${EFI_MOUNTPOINT}"
						fi
						;;
					another)
						read -p "Mountpoint [ex: /home]" directory
						[[ $directory == "/boot" ]] && BOOT_MOUNTPOINT=`echo ${partition} | sed 's/[0-9]//'`
						select_filesystem
						read_input_text "Format ${partition} partition"
						if [[ $OPTION == y ]]; then
							format_partition "${partition}" "$MOUNTPOINT}${directory}" dir="${directory}""
							if [[ $OPTION == y ]]; then
								mkdir -p ${MOUNTPOINT}${directory}
								mount -t ${filesystem} ${partition} ${MOUNTPOINT}${directory}
								check_mountpoint "${partition}" "${MOUNTPOINT}${directory}"
							fi
						fi
						;;
				esac
				break
			else
				echo -n "invalid selection"
			fi
		done
	fi
	# check usage all partitions
	if [[ $[#partitions_name[i]} == another ]]; then
		read_input_text "Configure more partitions"
		[[ $OPTION != y ]] && break
	fi
done
pause_function
}
#}}}
#INSTALL BASE SYSTEM {{{
select_linux_version() {
	print_title "LINUX VERSION"
	version_list=("linux (default)" "linux-lts (long term support)" "linux-hardened (security features)");
		PS3="$prompt1"
		echo -e "Select linux version to install\n"
		select VERSION in "${version_list[@]}"; do
			if contains_element "$VERSION" "${version_list[@]}"; then
finish(){
	print_title "INSTALL COMPLETED"
	#

				
partition_usb() {
        local dev="$1"; shift
        sgdisk --zap-all "$dev"
        sgdisk -p "$dev"
        sgdisk -g "$dev"
        sgdisk -n 1:2048:1050623 -t 1:ef00 -g -p "$dev"
        sgdisk -n 2:1050624:1460223 -g -t 2:8300 -p "$dev"
        sgdisk -c 1:"EFI" -c 2:"LINUX"
}

format_usb() {
	local dev="$1"; shift
	mkfs.vfat -F 32 "$dev"
}
cryptsetup_usb() {
        local dev="$1"; shift
	cryptsetup -v --cipher aes-xts-plain64 --key-size=512 --hash=sha512 --iter-time=5000 --use-random --verify-passphrase luksFormat "$dev"
	cryptsetup open "$dev" encboot
	mkfs.ext4 /dev/mapper/encboot
}

set_usb002() {
	mount /dev/mapper/encboot /mnt
	dd if=/dev/urandom of=/mnt/key.img bs=256M count=1
	cryptsetup --align-payload=1 luksFormat /mnt/key.img
	cryptsetup open /mnt/key.img lukskey
}

set_main() {
        local dev="$1"; shift
        truncate -s 16M /mnt/header.img
        cryptsetup --key-file=/dev/mapper/lukskey --keyfile-offset=4 --keyfile-size=8192 luksFormat $dev enc --align-payload 4096 --header /mnt/header.img
        cryptsetup open --header /mnt/header.img --key-file=/dev/mapper/lukskey --keyfile-offset=4 --keyfile-size=8192 $dev enc
        cryptsetup close lukskey
	umount /mnt
        pvcreate /dev/mapper/enc
        vgcreate MVG /dev/mapper/enc
	lvcreate -L 8G MVG -n swap
        lvcreate -L 32G MVG -n root
        lvcreate -l 100%FREE MVG -n home
	mkfs.ext4 /dev/MVG/root
        mkfs.ext4 /dev/MVG/home
        mkswap /dev/MVG/swap
        mount /dev/MVG/root /mnt
        mkdir /mnt/home
        mount /dev/MVG/home /mnt/home
        swapon /dev/MVG/swap
}
set_mount() {
	mkdir /mnt/boot
	mkdir /mnt/efi
	mount /dev/mapper/encboot /mnt/boot
	mount /dev/sdb1 /mnt/efi
}

ls -l /dev/disk/by-id/
partition_usb /dev/sdc
format_usb /dev/sdc1
cryptsetup_usb /dev/sdc2
set_usb002
set_main /dev/sda
set_mount 

pacstrap /mnt base base-devel
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
hwclock --systohc
locale-gen
echo LANG=en_UTF-8 >> /etc/locale.conf
echo anotherlight >> /etc/hostname


## for customencrypthook porition
##+write file customencrypthook to usb 
##+p file to /etc/initcpio/install/
##+then cp /usr/lib/initpcio/install/encrypt
##+edit mkinitcpio.conf file using sed pattern matching
##+delete pattern 'full string 001' insert pattern 'full string 002'
## example format below
## sed -i s'/replace and substitute000/replace and substitute001/' sedexample.txt
##
## cp /usr/lib/initpcio/install/encrypt /etc/initcpio/install/customencrypthook





