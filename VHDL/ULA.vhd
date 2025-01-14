
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MUX2x1_8BITS is
    port(R_data, R_ULA: std_logic_vector (7 downto 0); 
			RF_S: in std_logic;
      C: out std_logic_vector (7 downto 0));
end MUX2x1_8BITS;
 
architecture hardware of MUX2x1_8BITS is
 
begin
 
    C(0) <= (R_ULA(0) and (not RF_S)) or (R_data(0) and RF_S);
	C(1) <= (R_ULA(1) and (not RF_S)) or (R_data(1) and RF_S);
	C(2) <= (R_ULA(2) and (not RF_S)) or (R_data(2) and RF_S);
	C(3) <= (R_ULA(3) and (not RF_S)) or (R_data(3) and RF_S);
	C(4) <= (R_ULA(4) and (not RF_S)) or (R_data(4) and RF_S);
	C(5) <= (R_ULA(5) and (not RF_S)) or (R_data(5) and RF_S);
	C(6) <= (R_ULA(6) and (not RF_S)) or (R_data(6) and RF_S);
	C(7) <= (R_ULA(7) and (not RF_S)) or (R_data(7) and RF_S);

end hardware;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Comparador8bits is
    port(
      reg_a, reg_b: in std_logic_vector (7 downto 0);  
      Comp_eq, Comp_max , Comp_menor : out std_logic
    );
    
  end Comparador8bits;
  
  
  architecture saida_comparador of Comparador8bits is
    
    signal X, Y, Z: std_logic_vector(7 downto 0);
    
  begin
    
  -- Verifica de reg_a eh igual a reg_b
    
    X(0)<= not(reg_a(0) xor reg_b(0));
    X(1)<= not(reg_a(1) xor reg_b(1));
    X(2)<= not(reg_a(2) xor reg_b(2));
    X(3)<= not(reg_a(3) xor reg_b(3));
    X(4)<= not(reg_a(4) xor reg_b(4));
    X(5)<= not(reg_a(5) xor reg_b(5));
    X(6)<= not(reg_a(6) xor reg_b(6));
    X(7)<= not(reg_a(7) xor reg_b(7));
   
   -- Verifica que reg_a eh maior q reg_b
    
    Y(0)<= X(7) and X(6) and X(5) and X(4) and X(3) and X(2) and X(1) and reg_a(0) and not(reg_b(0));
    Y(1)<= X(7) and X(6) and X(5) and X(4) and X(3) and X(2) and reg_a(1) and not(reg_b(1));
    Y(2)<= X(7) and X(6) and X(5) and X(4) and X(3) and reg_a(2) and not(reg_b(2));
    Y(3)<= X(7) and X(6) and X(5) and X(4) and reg_a(3) and not(reg_b(3));
    Y(4)<= X(7) and X(6) and  X(5) and reg_a(3) and not(reg_b(4));
    Y(5)<= X(7) and X(6) and reg_a(5) and not(reg_b(5));
    Y(6)<= X(7) and reg_a(6) and not(reg_b(6));
    Y(7)<= reg_a(7) and not(reg_b(7));
   
   
   -- Verifica que reg_a menor q reg_b
    Z(0)<= X(7) and X(6) and X(5) and X(4) and X(3) and X(2) and X(1) and reg_b(0) and not(reg_a(0));
    Z(1)<= X(7) and X(6) and X(5) and X(4) and X(3) and X(2) and reg_b(1) and not(reg_a(1));
    Z(2)<= X(7) and X(6) and X(5) and X(4) and X(3) and reg_b(2) and not(reg_a(2));
    Z(3)<= X(7) and X(6) and X(5) and X(4) and reg_b(3) and not(reg_a(3));
    Z(4)<= X(7) and X(6) and  X(5) and reg_b(3) and not(reg_a(4));
    Z(5)<= X(7) and X(6) and reg_b(5) and not(reg_a(5));
    Z(6)<= X(7) and reg_b(6) and not(reg_a(6));
    Z(7)<= reg_b(7) and not(reg_a(7));
   
    
  
     
    -- Verifica se o n�mero de mensagens lidas � igual a o n�mero de mensagens escritas
    
    Comp_eq <= X(7) and X(6) and X(5) and X(4) and X(3) and X(2) and X(1) and X(0);    
    
    -- Verifica se o n�mero de mensagens escritas j� chegou � 25, n�mero m�ximo
    
    Comp_max <= Y(7) or Y(6) or Y(5) or Y(4) or Y(3) or Y(2) or Y(1) or Y(0);
    
    -- Verifica se h� ou n�o mensagem na secret�ria eletr�nica
    
    Comp_menor <= Z(7) or Z(6) or Z(5) or Z(4) or Z(3) or Z(2) or Z(1) or Z(0); 
    
    
  end saida_comparador;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity COMP8 is
    port(
        A, B: in std_logic_vector(7 downto 0);
        O: out std_logic_vector(7 downto 0);
        CO: out std_logic

    );
    end COMP8;

    architecture main of COMP8 is

    component Comparador8bits is
        port(
          reg_a, reg_b: in std_logic_vector (7 downto 0);  
          Comp_eq, Comp_max , Comp_menor : out std_logic
        );
      end component;

    component MUX2x1_8BITS is
        port(R_data, R_ULA: std_logic_vector (7 downto 0); 
                RF_S: in std_logic;
          C: out std_logic_vector (7 downto 0));
    end component;
    
    component MUX21 is
        port(A, B, S: in std_logic;
                O: out std_logic);
    end component MUX21;

    signal SwEQ,SwMAX,SwMN: std_logic;

    begin

        u1: Comparador8bits port map(A, B, SwEQ, SwMAX, SwMN); 
        u2: MUX2x1_8BITS port map("00000001", "00000000", SwMAX,O);
        u3: MUX21 port map('0','1',SwEQ,CO);

    end main;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M O V E
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity MOVE8 is
    port(
        A, B: in std_logic_vector(7 downto 0);
        Bout: out std_logic_vector(7 downto 0)
    );

    end MOVE8;

    architecture main of MOVE8 is

        begin
        
        Bout(0) <= B(0);
        Bout(1) <= B(1);
        Bout(2) <= B(2);
        Bout(3) <= B(3);
        Bout(4) <= B(4);
        Bout(5) <= B(5);
        Bout(6) <= B(6);
        Bout(7) <= B(7);

    end main;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M E I O    S O M D A D O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity HALF_ADD is
    port(A, B: in std_logic;
            S, CO: out std_logic);
end HALF_ADD;

architecture hardware of HALF_ADD is

begin
    S <= A xor B;
    CO <= A and B;
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S O M A D O R    C O M P L E T O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity COMP_ADD is
    port(A, B, CI: in std_logic;
            S, CO: out std_logic);
end COMP_ADD;

architecture hardware of COMP_ADD is

begin
    S <= A xor B xor CI;
    CO <= (B and CI) or (A and CI) or (A and B);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S O M A D O R    D E     8   B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ADD8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            CO: out std_logic);
end ADD8;

architecture hardware of ADD8 is

component HALF_ADD is
    port(A, B: in std_logic;
        S, CO: out std_logic);
end component;

component COMP_ADD
    port(A, B, CI: in std_logic;
            S, CO: out std_logic);
end component;

signal VAI_UM: std_logic_vector(6 downto 0);

begin
    S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), B(7), VAI_UM(6), O(7), CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S U B T R A T O R    DE  8   B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity SUB is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            CO, Z: out std_logic);
end SUB;

architecture hardware of SUB is

component COMP_ADD
    port(A, B, CI: in std_logic;
            S, CO: out std_logic);
end component;

signal VAI_UM: std_logic_vector(6 downto 0);
signal AUX_B: std_logic_vector(7 downto 0);

begin
    -- Como é subtrator, então inverte B e soma 1 (VAI_UM='1'). (Complemento de 2: A-B=A+B'+1)

    AUX_B(0) <= not B(0);
    AUX_B(1) <= not B(1);
    AUX_B(2) <= not B(2);
    AUX_B(3) <= not B(3);
    AUX_B(4) <= not B(4);
    AUX_B(5) <= not B(5);
    AUX_B(6) <= not B(6);
    AUX_B(7) <= not B(7);

    S0: COMP_ADD port map(A(0), AUX_B(0), '1', O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), AUX_B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), AUX_B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), AUX_B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), AUX_B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), AUX_B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), AUX_B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), AUX_B(7), VAI_UM(6), O(7), CO);
end hardware ;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- A N D
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity AND8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end AND8;

architecture hardware of AND8 is

begin 
    O(0) <= A(0) and B(0);
    O(1) <= A(1) and B(1);
    O(2) <= A(2) and B(2);
    O(3) <= A(3) and B(3);
    O(4) <= A(4) and B(4);
    O(5) <= A(5) and B(5);
    O(6) <= A(6) and B(6);
    O(7) <= A(7) and B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity OR8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end OR8;

architecture hardware of OR8 is

begin
    O(0) <= A(0) or B(0);
    O(1) <= A(1) or B(1);
    O(2) <= A(2) or B(2);
    O(3) <= A(3) or B(3);
    O(4) <= A(4) or B(4);
    O(5) <= A(5) or B(5);
    O(6) <= A(6) or B(6);
    O(7) <= A(7) or B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- X O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity XOR8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end XOR8;

architecture hardware of XOR8 is

begin
    O(0) <= A(0) xor B(0);
    O(1) <= A(1) xor B(1);
    O(2) <= A(2) xor B(2);
    O(3) <= A(3) xor B(3);
    O(4) <= A(4) xor B(4);
    O(5) <= A(5) xor B(5);
    O(6) <= A(6) xor B(6);
    O(7) <= A(7) xor B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- N O T
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity NOT8 is
    port(A: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end NOT8;

architecture hardware of NOT8 is

begin
    O(0) <= not A(0);
    O(1) <= not A(1);
    O(2) <= not A(2);
    O(3) <= not A(3);
    O(4) <= not A(4);
    O(5) <= not A(5);
    O(6) <= not A(6);
    O(7) <= not A(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    2 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity MUX21 is
    port(A, B, S: in std_logic;
            O: out std_logic);
end MUX21;

architecture hardware of MUX21 is

begin
    O <= (B and S) or (A and (not S));
end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            -- B I T    Z E R O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ZERO is                          -- Checar se o vetor de saída da ULA é nulo                    
    port(O: in std_logic_vector(7 downto 0);
            Z: out std_logic);
end ZERO;

architecture hardware of ZERO is

component NOT8 is
    port(A: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end component;

signal NO: std_logic_vector(7 downto 0);

begin
    
    NOT_O: NOT8 port map(O, NO);

    Z <= (NO(0) and NO(1) and NO(2) and NO(3) and 
          NO(4) and NO(5) and NO(6) and NO(7));

end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    8 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity MUX8x1 is
    port (A: in std_logic_vector(7 downto 0);
            S: in std_logic_vector(2 downto 0);
            E: in std_logic;
            O: out std_logic);
end MUX8x1;

architecture hardware of MUX8x1 is

begin
    O <= (A(0) and (not S(2)) and (not S(1)) and (not S(0)) and (not E))
        or (A(1) and (not S(2)) and (not S(1)) and       S(0) and (not E))
        or (A(2) and (not S(2)) and       S(1) and (not S(0)) and (not E))
        or (A(3) and (not S(2)) and       S(1) and       S(0) and (not E))
        or (A(4) and       S(2) and (not S(1)) and (not S(0)) and (not E))
        or (A(5) and       S(2) and (not S(1)) and       S(0) and (not E))
        or (A(6) and       S(2) and       S(1) and (not S(0)) and (not E))
        or (A(7) and       S(2) and       S(1) and       S(0) and (not E));    
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    16 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity MUX16x1 is
    port (A: in std_logic_vector(15 downto 0);
            S: in std_logic_vector(3 downto 0);
            O: out std_logic);
end MUX16x1;

architecture hardware of MUX16x1 is

component MUX8x1
    port(A: in std_logic_vector(7 downto 0);
            S: in std_logic_vector(2 downto 0);
            E: in std_logic;
            O: out std_logic);
end component;

signal Z1, Z2, E2: std_logic;
signal AUX1, AUX2: std_logic_vector(7 downto 0);
signal SEL: std_logic_vector(2 downto 0);

begin
    AUX1 <= A(15 downto 8);
    AUX2 <= A(7 downto 0);
    SEL <= S(2 downto 0);
    E2 <= not S(3);

    MUX1: MUX8x1 port map(AUX1, SEL, E2, Z1);
    MUX2: MUX8x1 port map(AUX2, SEL, S(3), Z2);

    O <= Z1 or Z2;

end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            -- COMPONENTE AUXILIAR
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity AUXILIAR is
    port(O_ADD, O_SUB, O_AND8, O_OR8, O_NOT8, O_XOR8, O_COMP8, O_MOVE8: in std_logic;
            E: out std_logic_vector(15 downto 0));
end AUXILIAR;
 
architecture hardware of AUXILIAR is
begin
    E(0) <= O_ADD;
    E(1) <= O_SUB;
    E(2) <= O_AND8;
    E(3) <= O_OR8;
    E(4) <= O_NOT8;
    E(5) <= O_XOR8;
    E(6) <= O_COMP8;
    E(7) <= O_MOVE8;
    
    E(15 downto 8) <= "00000000";
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- U L A
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity ULA is
    port(A, B: in std_logic_vector(7 downto 0);
            S: in std_logic_vector(3 downto 0);
            O: out std_logic_vector(7 downto 0);
            C, Z: out std_logic);
end ULA;

architecture hardware of ULA is
-- Somador
component ADD8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            CO: out std_logic);
end component;

-- Subtrator
component SUB is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            CO: out std_logic);
end component;

-- AND8
component AND8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end component;

-- OR8
component OR8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end component;

-- NOT8
component NOT8 is
    port(A: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end component;

-- XOR8
component XOR8 is
    port(A, B: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0));
end component;

-- MOVE8
component MOVE8 is
    port(
        A, B: in std_logic_vector(7 downto 0);
        Bout: out std_logic_vector(7 downto 0));
end component;

component COMP8 is
    port(
        A, B: in std_logic_vector(7 downto 0);
        O: out std_logic_vector(7 downto 0);
        CO: out std_logic);
end component;

component AUXILIAR is
    port(O_ADD, O_SUB, O_AND8, O_OR8, O_NOT8, O_XOR8, O_COMP8, O_MOVE8: in std_logic;
            E: out std_logic_vector(15 downto 0));
end component;

component MUX16x1 is
    port (A: in std_logic_vector(15 downto 0);
            S: in std_logic_vector(3 downto 0);
            O: out std_logic);
end component;

component ZERO is                  
    port(O: in std_logic_vector(7 downto 0);
            Z: out std_logic);
end component;

    signal O_ADD, O_SUB, O_MOVE8, O_COMP8, O_AND8, O_OR8, O_XOR8, O_NOT8, O_AUX: std_logic_vector(7 downto 0); -- Resultado de cada operação
    signal E0, E1, E2, E3, E4, E5, E6, E7, AUX_CO: std_logic_vector(15 downto 0); -- Vetores que representararão cada uma das possíveis entradas para
                                                                              -- cada saída O(i) e que entrarão no MUX
begin
    SOMA: ADD8 port map(A, B, O_ADD, AUX_CO(0));
    SUBTRACAO: SUB port map(A, B, O_SUB, AUX_CO(1));
    PORTAAND: AND8 port map(A, B, O_AND8);
    PORTAOR: OR8 port map(A, B, O_OR8);
    PORTANOT: NOT8 port map(A, O_NOT8);
    PORTAXOR: XOR8 port map(A, B, O_XOR8);
    COMPARAR: COMP8 port map(A, B, O_COMP8);
    MOVER: MOVE8 port map(A, B, O_MOVE8);
    

    AUX_CO(8 downto 5) <= "0000";
    AUX_CO(15 downto 10) <= "000000";

    AUX0: AUXILIAR port map(O_ADD(0), O_SUB(0),O_AND8(0), O_OR8(0), O_NOT8(0), O_XOR8(0), O_COMP8(0), O_MOVE8(0), E0);

    AUX1: AUXILIAR port map(O_ADD(1), O_SUB(1),O_AND8(1), O_OR8(1), O_NOT8(1), O_XOR8(1), O_COMP8(1), O_MOVE8(1), E1);

    AUX2: AUXILIAR port map(O_ADD(2), O_SUB(2),O_AND8(2), O_OR8(2), O_NOT8(2), O_XOR8(2), O_COMP8(2), O_MOVE8(2), E2);

    AUX3: AUXILIAR port map(O_ADD(3), O_SUB(3),O_AND8(3), O_OR8(3), O_NOT8(3), O_XOR8(3), O_COMP8(3), O_MOVE8(3), E3);

    AUX4: AUXILIAR port map(O_ADD(4), O_SUB(4),O_AND8(4), O_OR8(4), O_NOT8(4), O_XOR8(4), O_COMP8(4), O_MOVE8(4), E4);

    AUX5: AUXILIAR port map(O_ADD(5), O_SUB(5),O_AND8(5), O_OR8(5), O_NOT8(5), O_XOR8(5), O_COMP8(5), O_MOVE8(5), E5);

    AUX6: AUXILIAR port map(O_ADD(6), O_SUB(6),O_AND8(6), O_OR8(6), O_NOT8(6), O_XOR8(6), O_COMP8(6), O_MOVE8(6), E6);

    AUX7: AUXILIAR port map(O_ADD(7), O_SUB(7),O_AND8(7), O_OR8(7), O_NOT8(7), O_XOR8(7), O_COMP8(7), O_MOVE8(7), E7);

    SAIDA0: MUX16x1 port map(E0, S, O_AUX(0));
    SAIDA1: MUX16x1 port map(E1, S, O_AUX(1));
    SAIDA2: MUX16x1 port map(E2, S, O_AUX(2));
    SAIDA3: MUX16x1 port map(E3, S, O_AUX(3));
    SAIDA4: MUX16x1 port map(E4, S, O_AUX(4));
    SAIDA5: MUX16x1 port map(E5, S, O_AUX(5));
    SAIDA6: MUX16x1 port map(E6, S, O_AUX(6));
    SAIDA7: MUX16x1 port map(E7, S, O_AUX(7));

    
    CARRYOUT: MUX16x1 port map(AUX_CO, S, C);
    CARRYZERO: ZERO port map(O_AUX, Z);

    O(7 downto 0) <= O_AUX(7 downto 0);    
end hardware;