#include <efi.h>
#include <efilib.h>

EFI_STATUS
efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *system_table)
{
    EFI_STATUS status;
    EFI_INPUT_KEY key;
    UINTN event_index;

    InitializeLib(image_handle, system_table);

    Print(L"\r\n");
    Print(L"Boot6 UEFI application\r\n");
    Print(L"UEFI + GPT boot completed successfully.\r\n");
    Print(L"\r\n");
    Print(L"Press any key to exit...\r\n");

    status = uefi_call_wrapper(
        system_table->BootServices->WaitForEvent,
        3,
        1,
        &system_table->ConIn->WaitForKey,
        &event_index
    );

    if (EFI_ERROR(status)) {
        Print(L"WaitForEvent failed: %r\r\n", status);
        return status;
    }

    status = uefi_call_wrapper(
        system_table->ConIn->ReadKeyStroke,
        2,
        system_table->ConIn,
        &key
    );

    return status;
}


/*

    EFI_INPUT_KEY key;

    InitializeLib(image, system);

    ST->ConOut->ClearScreen(ST->ConOut);

    Print(L"LabBoot: UEFI/GPT\r\n");
    Print(L"=================\r\n\r\n");

    Print(L"Esta aplicacao foi carregada diretamente pelo firmware UEFI.\r\n");
    Print(L"O disco usa uma tabela de particoes GPT.\r\n");
    Print(L"A aplicacao encontra-se na EFI System Partition.\r\n\r\n");

    Print(L"Caminho: EFI\\BOOT\\BOOTX64.EFI\r\n\r\n");

    Print(L"Nao foi executado codigo no MBR.\r\n");
    Print(L"Nao foi utilizado um bootloader.\r\n\r\n");

    Print(L"Prima uma tecla para terminar.\r\n");

    ST->ConIn->Reset(ST->ConIn, FALSE);

    while (ST->ConIn->ReadKeyStroke(ST->ConIn, &key) == EFI_NOT_READY) {
        Print(L"LabBoot: UEFI/GPT\r\n");
    }

    return EFI_SUCCESS;
}
*/
