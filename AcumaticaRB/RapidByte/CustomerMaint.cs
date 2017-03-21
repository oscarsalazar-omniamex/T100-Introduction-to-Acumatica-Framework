using System;
using System.Collections;
using System.Collections.Generic;
using PX.SM;
using PX.Data;


namespace AcumaticaRB.RapidByte
{
    public class CustomerMaint : PXGraph<CustomerMaint>
    {
        public PXSelect<Customer> Customers;

    }
}