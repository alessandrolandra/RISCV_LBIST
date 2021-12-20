set target_library {NangateOpenCellLibrary_typical_ccs_scan.db}
set link_library [list $target_library $synthetic_library]
#set_dont_use "NangateOpenCellLibrary/SDFFRS_X1"
#set_dont_use "NangateOpenCellLibrary/SDFFRS_X2"
#set_dont_use "NangateOpenCellLibrary/SDFFR_X1"
#set_dont_use "NangateOpenCellLibrary/SDFFR_X2"
#set_dont_use "NangateOpenCellLibrary/SDFFS_X1"
#set_dont_use "NangateOpenCellLibrary/SDFFS_X2"
#set_dont_use "NangateOpenCellLibrary/SDFF_X1"
#set_dont_use "NangateOpenCellLibrary/SDFF_X2"
#set_dont_use "NangateOpenCellLibrary/DLH_X1"
#set_dont_use "NangateOpenCellLibrary/DLH_X2"
#set_dont_use "NangateOpenCellLibrary/DLL_X1"
#set_dont_use "NangateOpenCellLibrary/DLL_X2"
set DFF_CELL DFF_X2
set LIB_DFF_D NangateOpenCellLibrary/DFF_X2/D
set OPER_COND typical



