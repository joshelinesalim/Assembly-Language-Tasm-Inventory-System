.model small
.stack 100h
.data
        arr db 0ah, '$               5 '
            db 0ah, 'NO', 09h, 'ITEM   ', 09h, 09h, 'CAT', 09h, 'Q', '$'
            db 0ah, '$               5 '
            db 0ah, '1 ', 09h, 'Whisk  ', 09h, 09h, 'MIX', 09h, '2', '$'
            db 0ah, '2 ', 09h, 'Mixer  ', 09h, 09h, 'MIX', 09h, '5', '$'
            db 0ah, '3 ', 09h, 'Spatula', 09h, 09h, 'MIX', 09h, '8', '$'
            db 0ah, '4 ', 09h, 'Spoon  ', 09h, 09h, 'MSR', 09h, '3', '$'
            db 0ah, '5 ', 09h, 'Cup    ', 09h, 09h, 'MSR', 09h, '6', '$'
            db 0ah, '6 ', 09h, 'Knife  ', 09h, 09h, 'CUT', 09h, '9', '$'
            db 0ah, '7 ', 09h, 'Grater ', 09h, 09h, 'CUT', 09h, '7', '$'
            db 0ah, '8 ', 09h, 'Slicer ', 09h, 09h, 'CUT', 09h, '4', '$'
            db 0ah, '9 ', 09h, 'Peeler ', 09h, 09h, 'CUT', 09h, '1', '$'
            db 0ah, '$               5 ' 
        msg db 09h, 'NEEDS RESTOCK$'
        wel db 0ah, 'JESS BAKING SUPPLIES INVENTORY$'
        mnu db 0ah, 'What would you like to do today?', 0ah
            db '1. Make Sales', 0ah
            db '2. Reorder Items', 0ah
            db '3. Edit Item Quantity', 0ah
            db '4. Exit Program', 0ah
            db 0ah, 'Please select an activity (1/2/3/4): $'
        sa1 db 0ah, 'Please select an item to make sales (1/2/3/4/5/6/7/8/9): $'
        sa2 db 0ah, 0ah, 'Please enter the quantity of the items sold: $'
        re1 db 0ah, 0ah, 'Please select an item to reorder (1/2/3/4/5/6/7/8/9): $'
        re2 db 0ah, 0ah, 'Please enter the quantity of the items reordered: $'
        ed1 db 0ah, 0ah, 'Please selct an item to edit quantity (1/2/3/4/5/6/7/8/9): $'
        ed2 db 0ah, 0ah, 'Please enter the new quantity of the items selected: $'
        sel db 0ah, 0ah, 'You have selected item number $'
        va1 db 0ah, 'The number you inputted is invalid. $'
        va2 db 0ah, 'The item number you inputted does not exist. $'
        ltn db 0ah, 'The quantity cannot be less than 0. $'
        mtn db 0ah, 'The quantity cannot be more than 9. $'
        pa1 db 0ah, 'Please enter password to view inventory: $'
        pas db 'adm00', '$'
        ext db 0ah, 'You are not authorized to view inventory. $'
        st1 db 6 dup(?)
.code

main proc
        mov ax, @data
        mov ds, ax

        mov ah, 09h
        mov dx, offset pa1
        int 21h

        mov si, offset st1
        mov cx, 6

strinp:
        mov ah, 01h
        int 21h
        mov [si], al
        cmp al, 0dh
        je lev1
        inc si

        loop strinp

lev1:

        mov si, offset st1
        mov di, offset pas
        mov cx, 5

cmpr:
        mov al, [si]
        cmp al, [di]
        jne noteq        
        inc si
        inc di

        loop cmpr

        jmp start

noteq:
        mov ah, 09h
        mov dx, offset ext
        int 21h

        jmp quit

start:
        mov ah, 09h
        mov dx, offset wel
        int 21h

print:
        mov si, offset arr
        mov cx, 13

loop1:
        mov ah, 09h
        lea dx, [si]
        int 21h

        mov bl, [si+17]
        sub bl, '0'
        cmp bl, 5
        jge skip

        push cx
        mov ah, 09h
        mov bh, 0
        mov bl, 06h
        mov cx, 20
        int 10h
        mov dx, offset msg
        int 21h
        pop cx

skip:
        add si, 19

        loop loop1

menu:
        mov ah, 09h
        mov dx, offset mnu
        int 21h

        mov ah, 01h
        int 21h
        sub al, '0'

        cmp al, 1
        je sales

        cmp al, 2
        je reorder

        cmp al, 3
        je edit

        cmp al, 5
        jge invalid

quit:
        mov ah, 4ch
        int 21h

invalid:
        mov ah, 09h
        mov dx, offset va1
        int 21h

        jmp start
sales:
        mov bh, 0

        mov ah, 09h
        mov dx, offset sa1
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        cmp al, 9
        jg notf

        add al, '0'
        jmp check

reorder:
        mov bh, 1

        mov ah, 09h
        mov dx, offset re1
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        cmp al, 9
        jg notf

        add al, '0'
        jmp check

edit:
        mov bh, 2

        mov ah, 09h
        mov dx, offset ed1
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        cmp al, 9
        jg notf

        add al, '0'
        jmp check

notf:
        mov ah, 09h
        mov dx, offset va2
        int 21h

        jmp start
check:
        mov si, offset arr

search:
        mov bl, [si+1]
        cmp al, bl
        je found

        add si, 19
        jmp search


found:

        cmp bh, 0
        je substract
        cmp bh, 1
        je addition
        cmp bh, 2
        je substitution

substract:

        mov ah, 09h
        mov dx, offset sel
        int 21h

        mov ah, 09h
        mov bh, 0
        mov bl, 03h
        mov cx, 1
        int 10h

        mov bh, [si+17]

        mov ah, 09h
        mov dx, offset sa2
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        sub bh, al

        sub bh, '0'
        cmp bh, 0
        jl lessthan

        add bh, '0'
        mov [si+17], bh

        jmp print

addition:

        mov ah, 09h
        mov dx, offset sel
        int 21h

        mov ah, 09h
        mov bh, 0
        mov bl, 03h
        mov cx, 1
        int 10h

        mov bh, [si+17]

        mov ah, 09h
        mov dx, offset re2
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        add bh, al

        sub bh, '0'
        cmp bh, 9
        jg morethan

        add bh, '0'
        mov [si+17], bh

        jmp print

substitution:

        mov ah, 09h
        mov dx, offset sel
        int 21h

        mov ah, 09h
        mov bh, 0
        mov bl, 03h
        mov cx, 1
        int 10h

        mov bh, [si+17]

        mov ah, 09h
        mov dx, offset ed2
        int 21h

        mov ah, 01h
        int 21h

        sub al, '0'
        cmp al, 0
        jl lessthan
        cmp al, 9
        jg morethan

        add al, '0'
        mov [si+17], al

        jmp print

lessthan:
         mov ah, 09h
         mov dx, offset ltn
         int 21h

         jmp start
morethan:
         mov ah, 09h
         mov dx, offset mtn
         int 21h

         jmp start
main endp
end main
