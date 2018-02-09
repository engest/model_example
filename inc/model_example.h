#include "systemc.h"
#include "simple_target_socket.h"
#include "simple_initiator_socket.h"
#include <vector>

using namespace std;
using namespace sc_core;
using namespace tlm_utils;
using namespace tlm;

class model_example : public sc_module
{
    public:
    model_example(sc_module_name name);
    void b_transport(tlm_generic_payload & trans, sc_time & delay);

    simple_target_socket<model_example> tsocket;
    simple_initiator_socket<model_example> isocket;

    sc_event start;
    vector<unsigned char> data_store;
};
