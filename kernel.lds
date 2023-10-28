OUTPUT_ARCH( "riscv" )

ENTRY( _start )

MEMORY
{
  ram  (wxa) : ORIGIN = 0x40000000, LENGTH = 128M
}

PHDRS
{
  text PT_LOAD;
  data PT_LOAD;
  bss PT_LOAD;
}


SECTIONS
{

  .text : {
    . = ALIGN(8);
    PROVIDE(_text_start = .);
    *(.text.init) *(.text .text.*)
    PROVIDE(_text_end = .);
    . = ALIGN(8);
  } >ram AT>ram :text

   PROVIDE(_global_pointer = .);

  .rodata : {
    . = ALIGN(8);
    PROVIDE(_rodata_start = .);
    *(.rodata .rodata.*)
    PROVIDE(_rodata_end = .);
    . = ALIGN(8);
  } >ram AT>ram :text

  .data : {
    . = ALIGN(8);
    PROVIDE(_data_start = .);
    *(.sdata .sdata.*) *(.data .data.*)
    PROVIDE(_data_end = .);
    . = ALIGN(8);
  } >ram AT>ram :data

  .bss : {
    . = ALIGN(8);
    PROVIDE(_bss_start = .);
    *(.sbss .sbss.*) *(.bss .bss.*)
    PROVIDE(_bss_end = .);
    . = ALIGN(8);
  } >ram AT>ram :bss

  .kstack : {
    . = ALIGN(16);
    . += 4K;
    _stack_start = .;
   }

  PROVIDE(_memory_start = ORIGIN(ram));
}
