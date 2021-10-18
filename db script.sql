

------------------------------------------
--BUILD AND POPULATE SCHEMA
------------------------------------------

CREATE TABLE Client (
    Client_Nbr      NUMBER(5),
    First_Name      VARCHAR2(20),
    Last_Name       VARCHAR2(20),
    Street          VARCHAR2(18),
    City            VARCHAR2(15),
    Prov_State      VARCHAR2(2),
    Postal_Code     VARCHAR2(7),
    Phone           VARCHAR2(12),
    Email           VARCHAR2(40),
        CONSTRAINT client_client#_pk PRIMARY KEY(Client_Nbr),
        --CHECKS THAT PROV_STATE IS A VALID PROVINCE IN CANADA
        CONSTRAINT client_prov_ck
                CHECK (Prov_State IN ('ON', 'QC', 'NS', 'NB', 'MB', 
                                'BC', 'PE', 'SK', 'AB', 'NL',
                                'NT', 'YT', 'NU'))
);

CREATE SEQUENCE client#
    START WITH 10001;

INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Anthony', 'Soprano', 'Walnut Dr', 'Kelowna', 'BC', 'V1T5K4', '604-000-1111', 'tony@sopranos.com');
INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Carmela', 'Soprano', 'Walnut Dr', 'Kelowna', 'BC', 'V1T5K4', '604-000-1112', 'carm@sopranos.com');
INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Paulie', 'Walnuts', 'Hoboken Dr', 'Revelstoke', 'BC', 'V4Y5E7', '604-123-1113', 'paulie@gaul.com');
INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Silvio', 'Dante', 'Cherry St', 'Kamloops', 'BC', 'V2G5C1', '604-456-3111', 'sil@dante.com');
INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Christopher', 'Moltisanti', 'Nutley Ave', 'Maple Ridge', 'BC', 'V2W59C', '604-789-2223', 'chris@molti.com');
INSERT INTO Client 
    VALUES (client#.NEXTVAL, 'Bobby', 'Baccala', 'Corrado Dr', 'Langley', 'BC', 'V9N5L0', '604-888-9090', 'bobby@bac.com');

CREATE TABLE Account (
    Account_Nbr     NUMBER(7),
    Balance         NUMBER(8, 2),
        CONSTRAINT account_client#_pk PRIMARY KEY(Account_Nbr)
);


CREATE SEQUENCE acct#
    START WITH 1000001;
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);
INSERT INTO Account 
    VALUES (acct#.NEXTVAL, 0);

CREATE TABLE Owns (
    /*Oracle RDBMS does not permit multiple primary keys within the same relation
    as required in the Assignment description data model. Moreover, since a
    client may hold multiple accounts, and vice versa, neither one can be a 
    primary key, so a new attribute and sequence were added for the PK in this
    relation*/
    Indx            NUMBER(2),
    Client_Nbr      NUMBER(5),
    Account_Nbr     NUMBER(7),
        --CONSTRAINT owns_client#_pk PRIMARY KEY(Client_Nbr),
        --CONSTRAINT owns_acct#_pk PRIMARY KEY(Account_Nbr),
        CONSTRAINT owns_indx_pk PRIMARY KEY(Indx),
        CONSTRAINT owns_client#_fk FOREIGN KEY (Client_Nbr)
            REFERENCES Client(Client_Nbr),
        CONSTRAINT owns_acct#_fk FOREIGN KEY (Account_Nbr)
            REFERENCES Account(Account_Nbr)
);

CREATE SEQUENCE own_num
    START WITH 1;
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10002, 1000001);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10003, 1000002);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10003, 1000003);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10004, 1000002);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10004, 1000003);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10005, 1000004);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10005, 1000005);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10006, 1000006);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10007, 1000001);
INSERT INTO Owns 
    VALUES (own_num.NEXTVAL, 10001, 1000007);

CREATE TABLE Tx_Type (
    Tx_Type_Code        CHAR(1),
    Tx_Type_Descript    VARCHAR(15),
        CONSTRAINT txType_txCode_pk PRIMARY KEY(Tx_Type_Code)
);

INSERT INTO Tx_Type 
    VALUES ('D', 'Deposit');
INSERT INTO Tx_Type 
    VALUES ('W', 'Withdrawal');
INSERT INTO Tx_Type 
    VALUES ('B', 'Bill Payment');
INSERT INTO Tx_Type 
    VALUES ('P', 'Purchase');
INSERT INTO Tx_Type 
    VALUES ('R', 'Return');

CREATE TABLE Transaction(
    Tx_Nbr          NUMBER(2),
    Account_Nbr     NUMBER(7),
    Tx_Type_Code    CHAR(1),
    --TIMESTAMP TYPE WAS USED INSTEAD OF DATE TYPE TO INCLUDE TIME
    Tx_Date         TIMESTAMP,
    Tx_Amount       NUMBER(8,2),
    Ref_Nbr         NUMBER(3),
        CONSTRAINT tx_tx#_pk PRIMARY KEY(Tx_Nbr),
        CONSTRAINT tx_acct#_fk FOREIGN KEY (Account_Nbr)
            REFERENCES Account(Account_Nbr),
        CONSTRAINT tx_txCode_fk FOREIGN KEY (Tx_Type_Code)
            REFERENCES Tx_Type(Tx_Type_Code)
);

CREATE SEQUENCE trans_num
    START WITH 1;
--TO_TIMESTAMP() WAS USED INSTEAD OF TO_DATE() TO INCLUDE TIME
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'X', TO_TIMESTAMP('MAY 1 2019 12:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 123.45, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000000, 'D', TO_TIMESTAMP('MAY 1 2019 12:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 234.56, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'D', TO_TIMESTAMP('MAY 1 2019 12:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 345.67, 111);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'D', TO_TIMESTAMP('MAY 1 2019 10:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 100.00, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'D', TO_TIMESTAMP('MAY 11 2019 11:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 200.00, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'D', TO_TIMESTAMP('MAY 21 2019 12:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 300.00, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'W', TO_TIMESTAMP('MAY 29 2009 10:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 50.00, 102);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'W', TO_TIMESTAMP('MAY 29 2009 11:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 75.00, 103);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000001, 'D', TO_TIMESTAMP('Jun 15 2019 1:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 123.45, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000002, 'D', TO_TIMESTAMP('MAY 15 2019 9:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 1000.00, 104);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000002, 'W', TO_TIMESTAMP('MAY 15 2019 9:05:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 456.78, 104);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000003, 'D', TO_TIMESTAMP('MAY 15 2019 9:10:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 456.78, 104);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000003, 'W', TO_TIMESTAMP('MAY 18 2019 2:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 500.00, 104);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000003, 'D', TO_TIMESTAMP('MAY 20 2019 1:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 100.00, 104);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000003, 'P', TO_TIMESTAMP('MAY 20 2019 2:50:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 65.78, 304);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000002, 'B', TO_TIMESTAMP('MAY 21 2019 9:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 100.00, 301);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000002, 'P', TO_TIMESTAMP('MAY 21 2019 10:00:00 AM', 
            'MON DD YYYY HH:MI:SS AM'), 200.00, 302);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000002, 'R', TO_TIMESTAMP('MAY 26 2019 12:34:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 50.00, 301);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000004, 'D', TO_TIMESTAMP('JUN 1 2019 1:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 2000.00, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000005, 'D', TO_TIMESTAMP('JUN 1 2019 1:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 2000.00, 101);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000004, 'D', TO_TIMESTAMP('JUN 1 2019 2:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 2000.00, 102);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000005, 'B', TO_TIMESTAMP('JUN 10 2019 12:00:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 3456.78, 301);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000005, 'B', TO_TIMESTAMP('JUN 15 2019 2:30:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 432.10, 302);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000005, 'B', TO_TIMESTAMP('JUN 20 2019 3:55:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 100.00, 303);
INSERT INTO Transaction 
    VALUES (trans_num.NEXTVAL, 1000005, 'B', TO_TIMESTAMP('JUN 25 2019 4:56:00 PM', 
            'MON DD YYYY HH:MI:SS AM'), 80.00, 304);

CREATE TABLE Bank_Branch (
    Branch_Nbr  NUMBER(3),
    Branch_Name VARCHAR2(20)
);

CREATE SEQUENCE branch#
    START WITH 101;
INSERT INTO Bank_Branch 
    VALUES (branch#.NEXTVAL, 'Victoria');
INSERT INTO Bank_Branch 
    VALUES (branch#.NEXTVAL, 'Kamloops');
INSERT INTO Bank_Branch 
    VALUES (branch#.NEXTVAL, 'Vancouver');
INSERT INTO Bank_Branch 
    VALUES (branch#.NEXTVAL, 'Kelowna');

CREATE TABLE Merchant (
    Merchant_Nbr    NUMBER(3),
    Branch_Name     VARCHAR2(20)
);

CREATE SEQUENCE merchant#
    START WITH 301;
INSERT INTO Merchant 
    VALUES (merchant#.NEXTVAL, 'Alpha');
INSERT INTO Merchant 
    VALUES (merchant#.NEXTVAL, 'Beta');
INSERT INTO Merchant 
    VALUES (merchant#.NEXTVAL, 'Gamme');
INSERT INTO Merchant 
    VALUES (merchant#.NEXTVAL, 'Delta');

COMMIT;
------------------------------------------
--VIEWS
------------------------------------------

--2.1
CREATE VIEW TransactionType
    as SELECT * FROM 
    transaction NATURAL JOIN tx_type;

--2.2
create view clientOwns
    as select c.Client_Nbr, o.Account_Nbr, c.First_Name, 
        c.Last_Name, c.Street, c.City, c.Prov_State, 
        c.Postal_Code, c.Phone, c.Email 
        from Client c full join Owns o
        on c.Client_Nbr = o.Client_Nbr;


create view clientAccounts
    as select c.Client_Nbr, c.First_Name, c.last_name, 
        c.Account_Nbr, a.Balance
        from clientOwns c full join account a 
            on c.Account_Nbr = a.Account_Nbr;


--2.3
create view BankMerchantTransactions
    as (select Tx_Nbr from TransactionType t join 
            Bank_Branch b on t.Ref_Nbr = b.Branch_Nbr)
        union
        (select Tx_Nbr from TransactionType t join 
            Merchant m on t.Ref_Nbr = m.Merchant_Nbr);

------------------------------------------
--QUERIES
------------------------------------------

--3.1
select account_nbr, count(*) as clients 
    from clientAccounts group by account_nbr 
    having count(*) > 1;

--3.2
select client_nbr, first_name, last_name, count(account_nbr) 
    as num_accounts, sum(balance) as total_balance 
    from clientAccounts group by client_nbr, last_name, first_name 
    order by last_name;

--3.3
select tx_type_descript as transaction_type, 
    count(*) as num_of_transactions, 
    sum(tx_amount) as total 
    from TransactionType 
    group by tx_type_descript;

--3.4

--select * from TransactionType;

--select account_nbr, tx_type_descript, tx_amount from TransactionType;

select account_nbr, min(tx_date) as first_tx 
    from TransactionType group by account_nbr;

--3.5
select account_nbr, tx_type_descript, count(*), 
    sum(tx_amount) as total from TransactionType 
    group by account_nbr, tx_type_descript 
    order by account_nbr;

------------------------------------------
--PL/SQL
------------------------------------------

--4.1

create or replace trigger Transaction_Ref_Nbr_Check
    before insert on Transaction
    referencing new as newrow
    for each row
begin
    if ((:newrow.Ref_Nbr < 101 or :newrow.Ref_Nbr > 104)
            and (:newrow.Ref_Nbr < 301 or :newrow.Ref_Nbr > 304))
        then
            raise_application_error(-20000, 'Invalid Branch or Merchant number');
    end if;
end;
/

--4.2
create or replace trigger update_account_balance
    after insert on Transaction
    for each row
begin
    if (:new.Tx_Type_Code = 'D' or :new.Tx_Type_Code = 'R')
        then 
            update Account set Balance = Balance + :new.Tx_Amount
                where Account.Account_Nbr = :new.Account_Nbr;
    elsif (:new.Tx_Type_Code = 'W' or :new.Tx_Type_Code = 'B'
            or :new.Tx_Type_Code = 'P')
        then
            update Account set Balance = Balance - :new.Tx_Amount
                where Account.Account_Nbr = :new.Account_Nbr;
    end if;
end;
/

--4.3

create or replace view audit_trans as
    select tx_nbr, account_nbr, tx_type_code, tx_date, tx_amount, ref_nbr, 
        sum(tx_amount) over (order by tx_date) as balance
        from transaction where account_nbr = 1000001 order by tx_date;
    
select * from transaction where account_nbr = 1000001 order by tx_date;
select * from audit_trans;

create or replace procedure audit_transactions_function (vAccount_Nbr number)
    is
    vTx_Nbr         Transaction.Tx_Nbr%TYPE;
    vTx_Type_Code   Transaction.Tx_Type_Code%TYPE;
    vTx_Date        Transaction.Tx_Date%TYPE;
    vTx_Amount      Transaction.Tx_Amount%TYPE;
    vRef_Nbr        Transaction.Ref_Nbr%TYPE;
    vBalance        number;
    cursor audit_cursor is
        select tx_nbr, tx_type_code, tx_date, tx_amount, ref_nbr, 
            sum(tx_amount) over (order by tx_date) as balance
            from transaction where account_nbr = vAccount_Nbr order by tx_date;
begin
    --OPEN CURSOR AND FETCH EACH ROW 
    open audit_cursor;
    dbms_output.put_line('-------------------------------------------Audit Statement for Account #: ' 
                        || vAccount_Nbr || 
                        (' -------------------------------------------'));
    loop
    
    --FETCH NEXT ROW OF TABLE
    fetch audit_cursor
        into vTx_Nbr, vTx_Type_Code, vTx_Date, vTx_Amount, vRef_Nbr, vBalance;
    exit when audit_cursor%NOTFOUND;
        
    --DISPLAY DATA
    dbms_output.put_line('Trans #: '|| vTx_Nbr ||', Trans Type Code: '  
                        || vTx_Type_Code ||', Trans Date: '|| vTx_Date 
                        || ', Trans Amt: '|| vTx_Amount ||', Ref #: '
                        || vRef_Nbr ||', Balance: '|| vBalance);
    end loop;
    --if audit_cursor%ISOPEN THEN CLOSE audit_cursor end if;
    
    --ERROR CONDITION - PRINT ERROR
    exception
        when others then
            dbms_output.put_line('Error detected');
            --if audit_cursor%ISOPEN THEN CLOSE audit_cursor end if;
end;
/

set serveroutput on;

/*truncate table transaction;
update account set balance = 0;
select * from transaction;
select * from account;*/

execute audit_transactions_function(1000001);

