#include <array>
#include <vector>

// http://sparksandflames.com/files/x86InstructionChart.html
enum op {
    CALL = 0xE8,
    RETN = 0xC3
};

std::vector<uint8_t> get_function_bytes(uintptr_t address) {
    std::vector<uint8_t> bytes; // unknown size, create a vector to store all bytes

    int offset = 0; // relative offset from address
    uint8_t current_byte = 0; // current byte (address + offset)

    while (current_byte != RETN) { // push bytes into the vector until a return opcode is found
        current_byte = *reinterpret_cast<uint8_t*>(address + offset); // save byte so we can check if it's a return opcode
        bytes.push_back(current_byte); // push byte intro vector
        offset++; // go to the next offset
    }

    return bytes; 
}

uintptr_t get_call_address(uintptr_t address) {
    int offset = 0; // relative offset from address
    uint8_t opcode = 0; // current byte (address + offset)

    while (opcode != RETN) { // go through bytes until it finds the return opcode
        // if the opcode is call, return the offsetted address
        if (opcode = *reinterpret_cast<uint8_t*>(address + offset); opcode == CALL ) { 
            return address + offset;
        }

        // otherwise, go to the next offset
        offset++;
    }

    return 0; // call opcode not found in the function
}

uintptr_t get_absolute(uintptr_t address) {
    auto relative = *reinterpret_cast<uintptr_t*>(address + 1); // relative address (+1 to skip the call opcode)
    return address + relative + 5; // ![still attempting to figure this out]
}
