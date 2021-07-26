#include <stddef.h>
#include "ll_cycle.h"

int ll_has_cycle(node *head) {
    /* TODO: Implement ll_has_cycle */
    if (head == NULL) return 0;
    node *ptr_1 = head;
    node *ptr_2 = head->next;
    while (ptr_2 != NULL) {
        if (ptr_2 == ptr_1) return 1;
        ptr_1 = ptr_1->next;
        for (int i = 0; i < 2; ++i){
            ptr_2 = ptr_2->next;
            if (ptr_2 == NULL) {
                return 0;
            }
        }
    }

}
