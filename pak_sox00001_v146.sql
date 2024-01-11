-- wrap iname=pak_sox00001_v146.sql oname=pak_sox00001_v146.wrp

-- CREATE OR REPLACE
-- package pcsox.PAK_SOX00001
-- is
--    function    gs return varchar2;
--    function    gsu return varchar2;
--    function    c(p_k in varchar2, p_s in varchar2) return raw;
--    function    d(p_k in varchar2, p_s in raw) return varchar2;
--    procedure   nuser(p_k in varchar2, p_i in varchar2, p_u in varchar2, p_r in varchar2, p_d in varchar2, p_t in varchar2 default 'P', p_p in varchar2 default null);
--    procedure   nuser(p_k in varchar2, p_u in varchar2, p_t in varchar2 default 'P');
--    function    ctr (c in varchar2) return raw;
--    function    ctv (r in raw) return varchar2;
--    --procedure   change_pass(p_k in varchar2, p_opertype in char default 'M', p_user in varchar2 default 'ACB299');
--    function    apura_disponibilidade (p_instance in varchar2, p_instid in number, p_month in number, p_notify in varchar2 default 'Y') return number;
--    procedure   coleta_sarbox_global;
--    procedure   coleta_sarbox (p_instance in varchar2 default '%', p_full in varchar2 default 'S', p_email in varchar2 default null, p_notify in varchar2 default 'Y', p_debug in boolean default false);
--    procedure   verifica_disponibilidade(p_email in varchar2 default null, p_notify in varchar2 default 'Y');
--    procedure   verifica_disp_instancia(p_instancia in varchar2);
--    procedure   report_disponibilidade(p_email in varchar2 default null, p_notify in varchar2 default 'Y');
--    procedure   verifica_export(p_dia in number default 1, p_email in varchar2 default null, p_notify in varchar2 default 'Y');
--    procedure   verifica_privsoutsi(p_email in varchar2 default null, p_notify in varchar2 default 'Y');
--    procedure   reports(p_email in varchar2 default null, p_month number default null, p_notify in varchar2 default 'Y');
--    procedure   verifica_node(p_email in varchar2 default null, p_notify in varchar2 default 'Y');
--    procedure   auto_verificacao(p_email in varchar2 default null);
--    procedure   getinfo_oem;
--    procedure   drop_user;
--    procedure   grava_log(p_instance in varchar2, p_table_name in varchar2, p_column_name in varchar2, p_rowvalue in varchar2, p_oldvalue in varchar2, p_newvalue in varchar2, p_instid in number default 1);
-- end;
-- /
-- alter package pcsox.pak_sox00001 compile timestamp '2006-10-20:15:20:32';

-- create or replace type pcsox.t_lista_jobs is table of varchar2(30);
-- /


create or replace
package body       pcsox.pak_sox00001
is
   /*
   ** não incluir declarações na package fazer isto somente no body
   ** valores constantes - escopo global e privado
   ** NA DÚVIDA NÃO ALTERE OS VALORES ABAIXO, ENTRE EM CONTATO (C0095265 - 27 9942 7450)
   ** a troca de senha do usuário operacao e pcsox faz que com os procediementos terminem com falha.
   **
   */
   w_str1            varchar2(50)   := 'ABCDEFGHIJKMNPQRSTUVWXYZ';
   w_str2            varchar2(50)   := 'ABCDEFGHIJKMNPQRSTUVWXYZ23456789';
   w_str3            varchar2(10)   := '23456789';
   w_wo              varchar2(255)  := '20636F6E6E65637420746F206F7065726163616F206964656E74696669656420627920617374726F6E6175747320';
   w_ws              varchar2(255)  := '20636F6E6E65637420746F207063736F78202020206964656E746966696564206279206433616436797274202020';
   w_mailhost        varchar2(64)   := 'mailbr.valeglobal.net';
   w_from            varchar2(64)   := 'abd-adm@vale.com';
   w_mailconn        utl_smtp.connection;
   w_crlf            varchar2(2)    := chr(13)||chr(10);
   
   /* Usado na execucao de jobs em paralelo */
   type t_array_alerts is table of integer index by varchar2(30);
   type t_array_sid_alert is table of varchar2(30);

   /*
   ** gravação de log uso de password
   */
   procedure  grava_logpass(p_function in varchar2, p_username in varchar2 default null)
   is
      w_username  v$session.username%type;
      w_osuser    v$session.osuser%type;
      w_machine   v$session.machine%type;
      w_program   v$session.program%type;
   begin
      select   upper(t1.username)
      ,        upper(t1.osuser)
      ,        upper(t1.machine)
      ,        upper(t1.program)
      into     w_username
      ,        w_osuser
      ,        w_machine
      ,        w_program
      from     v$session   t1
      where    t1.audsid = userenv('sessionid');
      insert into sarbox_sec_log
         (proc_call , datelog, username_call, osuser  , machine  , program  , username)
      values
         (p_function, sysdate, w_username   , w_osuser, w_machine, w_program, p_username);
   exception
      when others then null;
   end grava_logpass;


   /*
   ** gravação de log dados
   */
   procedure  grava_log(p_instance in varchar2, p_table_name in varchar2, p_column_name in varchar2, p_rowvalue in varchar2, p_oldvalue in varchar2, p_newvalue in varchar2, p_instid in number default 1)
   is
   begin
      insert into sarbox_instance_history
         (instance, table_name, column_name, rowvalue, dthistory, oldvalue, newvalue, inst_id)
      values
         (p_instance, p_table_name, p_column_name, p_rowvalue, sysdate, p_oldvalue, p_newvalue, p_instid);
   exception
      when others then null;
   end grava_log;

   /*
   ** geracao de senha para oracle
   */
   function gs return varchar2
   as
      w_strlen1   number       := length(w_str1);
      w_strlen2   number       := length(w_str2);
      w_strlen3   number       := length(w_str3);
      w_pwd       varchar2(15);
      w_car_a     char;
      w_car_n     char;
      w_car_n_t   char;
      w_car_v     number;
      w_var_v_p   number;
      w_val       boolean := false;
      w_contnum   number;
      i           integer;
   begin
      while w_val = false
      loop
         -- primeiro caracter
         w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         w_pwd   := w_car_n;
         w_car_a := w_car_n;
         -- do segundo ao setimo caracter
         for i in 1 .. 6
         loop
            w_car_n := substr(w_str2, dbms_random.value(1, w_strlen2), 1);
            /*
            ** faz a verificao se o caracter atual e igual, anterior ou posterior
            */
            while (ascii(w_car_a) = ascii(w_car_n)) or (ascii(w_car_a) = (ascii(w_car_n)-1)) or (ascii(w_car_a) = (ascii(w_car_n)+1))
            loop
               w_car_n := substr(w_str2, dbms_random.value(1, w_strlen2), 1);
            end loop;
            w_car_a := w_car_n;
            w_pwd   := w_pwd || w_car_n;
         end loop;
         w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         while (ascii(w_car_a) = ascii(w_car_n)) or (ascii(w_car_a) = (ascii(w_car_n)-1)) or (ascii(w_car_a) = (ascii(w_car_n)+1))
         loop
            -- oitavo caracter
            w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         end loop;
         w_pwd   := w_pwd || w_car_n;
         /*
         ** tem que ter dois números em posicao aleatoria - nao pode iniciar nem terminar por numero
         */
         w_contnum := 0;
         w_car_v   := 0;
         w_var_v_p := 0;
         w_car_n_t := 0;
         for i in 1 .. length(w_pwd) -- requer 8 caracters: 1 + 6 + 1
         loop
            if instr(w_str3, substr(w_pwd, i, 1)) <> 0 then
               if (w_car_v <> substr(w_pwd, i, 1)) and ((w_var_v_p + 1) <> i) then
                  w_var_v_p := i;
                  w_contnum := w_contnum + 1;
               end if;
               w_car_n_t := w_car_n_t + 1;
               w_car_v := substr(w_pwd, i, 1);
            end if;
         end loop;
         if (w_car_n_t = 2) and (w_contnum = 2) and (substr(w_pwd, 1, 1) <> substr(w_pwd, -1, 1)) then
            w_val := True;
         end if;
      end loop;
      return lower(w_pwd);
   end gs;

   /*
   ** geracao de senha para unix
   */
   function gsu return varchar2
   as
      w_strlen1   number       := length(w_str1);
      w_strlen2   number       := length(w_str2);
      w_strlen3   number       := length(w_str3);
      w_pwd       varchar2(15);
      w_car_a     char;
      w_car_n     char;
      w_car_n_t   char;
      w_car_v     number;
      w_var_v_p   number;
      w_val       boolean := false;
      w_contnum   number;
      i           integer;
   begin
      loop
         w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         w_pwd   := w_car_n;
         w_car_a := w_car_n;
         for i in 1 .. 6
         loop
            w_car_n := substr(w_str2, dbms_random.value(1, w_strlen2), 1);
            /*
            ** faz a verificacao se o caracter atual e igual, anterior ou posterior
            */
            while (ascii(w_car_a) = ascii(w_car_n)) or (ascii(w_car_a) = (ascii(w_car_n)-1)) or (ascii(w_car_a) = (ascii(w_car_n)+1))
            loop
               w_car_n := substr(w_str2, dbms_random.value(1, w_strlen2), 1);
            end loop;
            w_car_a := w_car_n;
            w_pwd   := w_pwd || w_car_n;
         end loop;
         w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         while (ascii(w_car_a) = ascii(w_car_n)) or (ascii(w_car_a) = (ascii(w_car_n)-1)) or (ascii(w_car_a) = (ascii(w_car_n)+1))
         loop
            w_car_n := substr(w_str1, dbms_random.value(1, w_strlen1), 1);
         end loop;
         w_pwd   := w_pwd || w_car_n;
         /*
         ** tem que ter 4 números
         */
         w_contnum := 0;
         w_car_v   := 0;
         w_var_v_p := 0;
         w_car_n_t := 0;
         for i in 1 .. length(w_pwd)
         loop
            if instr(w_str3, substr(w_pwd, i, 1)) <> 0 then
               if (w_car_v <> substr(w_pwd, i, 1)) and ((w_var_v_p + 1) <> i) then
                  w_var_v_p := i;
                  w_contnum := w_contnum + 1;
               end if;
               w_car_n_t := w_car_n_t + 1;
               w_car_v := substr(w_pwd, i, 1);
            end if;
         end loop;
         if (w_car_n_t = 4) and (w_contnum = 3) and (substr(w_pwd, 1, 1) <> substr(w_pwd, -1, 1)) then
            w_val := True;
         end if;
      end loop;
      return lower(w_pwd);
   end gsu;

   /*
   ** funcao de criptografia
   */
   function c(p_k in varchar2, p_s in varchar2) return raw
   as
     l_data  varchar2(255);
   begin
      l_data := rpad(upper(p_s), (trunc(lengthb(upper(p_s))/8)+1)*8, chr(0));
      return dbms_obfuscation_toolkit.desencrypt(input => utl_raw.cast_to_raw(l_data), key => utl_raw.cast_to_raw(p_k));
   end c;

   /*
   ** funcao de decriptografia
   */
   function d(p_k in varchar2, p_s in raw) return varchar2
   as
      w_rpass varchar2(50);
   begin
      w_rpass := utl_raw.cast_to_varchar2(dbms_obfuscation_toolkit.desdecrypt(input => p_s, key => utl_raw.cast_to_raw(p_k)));
      return replace(w_rpass, chr(0), '');
   end d;

   /*
   ** procedure de novo usuário
   */
   procedure nuser(p_k in varchar2, p_i in varchar2, p_u in varchar2, p_r in varchar2, p_d in varchar2, p_t in varchar2 default 'P', p_p in varchar2 default null)
   as
      w_countpass number;
      w_pass      varchar2(100);
      w_descricao sarbox_user_description.description%type;
   begin
      grava_logpass('nuser cadastro', p_u);
      commit;

      if p_d is null then
         raise_application_error(-20003, 'Descrição para o usuário inválida. A descrição deve conter pelo menos 2 palavras e 15 caracteres.'||chr(10)||'O parâmetro p_d é obrigatório.', false);
      else
         w_descricao := trim(p_d);
         if length(w_descricao) >= 15 and instr(w_descricao, ' ') <> 0 then
            /*
            ** insere o usuario na sarbox_instance_user
            */
            begin
               insert
                  into sarbox_instance_user
                     (instance, username, status, owner, dtinsert, dtupdate, profile, rdbms, tpcarga)
                  values
                     (upper(p_i), upper(p_u), 'OPEN', 'UNDEF', sysdate, sysdate, '', upper(p_r), 'M');
            exception
               when dup_val_on_index then
                  null;
            end;
            /*
            ** grava a descricao do usuario, Esta descricao e obrigatoria.
            */
            begin
               insert into sarbox_user_description
                  (username, description)
               values
                  (upper(p_u), upper(w_descricao));
            exception
               when dup_val_on_index then
                  null;
            end;
            /*
            ** verifica se já existe a senha
            */
            w_countpass := 0;
            select count(*)
            into   w_countpass
            from   sarbox_user_password
            where  username = upper(p_u)
            and    type     = upper(p_t)
            and    dtgeracao >= trunc(sysdate-90);
            if w_countpass <> 0 then
               select pak_sox00001.d(p_k, password)
               into   w_pass
               from   sarbox_user_password t1
               where  username = upper(p_u)
               and    type     = upper(p_t)
               and    dtgeracao = (select max(dtgeracao) from sarbox_user_password t2 where t2.username = t1.username and t2.type = t1.type);
            end if;

            /*
            ** gera nova senha se necessario
            */
            if w_countpass = 0 then
               if p_p is null then
                  w_pass := pak_sox00001.gs;
               else
                  w_pass := p_p;
               end if;
               /*
               ** grava nova senha
               */
               insert into sarbox_user_password(username, dtgeracao, password, userexec, terminal, type) values (upper(p_u), sysdate, pak_sox00001.c(p_k, w_pass), upper(user), userenv('terminal'), upper(p_t));
               commit;
            end if;
            raise_application_error(-20002, chr(10)||'========================================================'||chr(10)||'A senha do usuário '||chr(34)||upper(p_u)||chr(34)||' é '||chr(34)||lower(w_pass)||chr(34)||' no ambiente '||upper(p_t)||'.'||chr(10)||chr(10)||'========================================================', false);
         else
            raise_application_error(-20004, 'Descrição informada para o usuário inválida. A descrição deve conter pelo menos 2 palavras e 15 caracteres.', false);
         end if;
      end if;
   end nuser;

   /*
   ** funcao cast to raw
   */
   function ctr (c in varchar2) return raw
   as
      w_ctr raw(10000);
   begin
      w_ctr := utl_raw.cast_to_raw(c);
      return w_ctr;
   end ctr;

   /*
   ** funcao cast to varchar
   */
   function ctv (r in raw) return varchar2
   as
      w_ctv varchar2(255);
   begin
      w_ctv := utl_raw.cast_to_varchar2(r);
      return w_ctv;
   end ctv;

   /*
   ** pesquisa por senha
   */
   procedure nuser(p_k in varchar2, p_u in varchar2, p_t in varchar2 default 'P')
   as
      w_countpass number;
      w_pass      varchar2(100);
   begin
      grava_logpass('nuser consulta', p_u);
      commit;
      /*
      ** verifica se já existe a senha
      */
      w_countpass := 0;
      select count(*)
      into   w_countpass
      from   sarbox_user_password
      where  username = upper(p_u)
      and    type     = upper(p_t);
      if w_countpass <> 0 then
         select pak_sox00001.d(p_k, password)
         into   w_pass
         from   sarbox_user_password t1
         where  username = upper(p_u)
         and    type     = upper(p_t)
         and    dtgeracao = (select max(dtgeracao) from sarbox_user_password t2 where t2.username = t1.username and t2.type = t1.type);
      end if;

      /*
      ** gera nova senha se necessario
      */
      if w_countpass = 0 then
         raise_application_error(-20002, chr(10)||'========================================================'||chr(10)||'O usuário '||chr(34)||upper(p_u)||chr(34)||' não possui senha cadastrada ou a senha foi gerada a mais de 90 dias.'||chr(10)||chr(10)||'========================================================', false);
      else
         raise_application_error(-20003, chr(10)||'========================================================'||chr(10)||'A senha do usuário '||chr(34)||upper(p_u)||chr(34)||' é '||chr(34)||lower(w_pass)||chr(34)||' no ambiente '||upper(p_t)||'.'||chr(10)||chr(10)||'========================================================', false);
      end if;
   end nuser;

   /*
   ** apura disponibilidade para uma instance em um determinado mês
   */
   function apura_disponibilidade (p_instance in varchar2, p_instid in number, p_month in number, p_notify in varchar2 default 'Y') return number
   as
   w_month     number;
   w_year      number;
   w_dayfirst  date;
   w_daylast   date;
   w_difant    number;
   w_difpos    number;
   w_dispacu   number;
   w_dispmax   number;
   w_maxdate   date;
   w_dtstart   date;
   w_dtshut    date;
   w_diftot    number;
   w_dif       number;
   w_return    number;
   begin
      w_month := p_month;
      w_dayfirst := trunc(to_date('01/'||p_month||'/'||extract(year from sysdate), 'dd/mm/rrrr'));
      if w_dayfirst > trunc(sysdate) then
         w_dayfirst := add_months(w_dayfirst, -12);
      end if;

      w_daylast  := add_months(w_dayfirst, 1);
      w_maxdate  := (trunc(sysdate)+(to_number(to_char(sysdate-2/24, 'hh24'))/24));
      if w_maxdate > w_daylast then
         w_maxdate := w_daylast;
      end if;
      w_year := extract(year from w_dayfirst);
      w_dispmax  := trunc(w_maxdate - w_dayfirst, 10);

      w_dispacu := 0;
      for r_startup in (select sis.instance, sis.instance_id, sis.startup_time, sis.dtstartup, sis.dtshutdown, extract(month from sis.dtstartup) mstt, extract(month from sis.dtshutdown) msht
                        from   sarbox_instance_startup sis
                        ,      sarbox_instance         si
                        where  si.instance     = sis.instance
                        and    sis.instance    = trim(upper(p_instance))
                        and    sis.instance_id = p_instid
                        and    si.notify like upper(p_notify)
                        and   ((extract(month from sis.dtstartup)  = w_month and extract(year  from sis.dtstartup)  = w_year)
                            or (extract(month from sis.dtshutdown) = w_month and extract(year  from sis.dtshutdown) = w_year)
                            or (extract(month from sis.dtstartup)  < w_month and extract(month from sis.dtshutdown) > w_month and extract(year  from sis.dtshutdown) = w_year))
                        order by sis.startup_time)
      loop
         w_dtstart := r_startup.dtstartup;
         w_dtshut  := r_startup.dtshutdown;
         w_difant := 0;
         w_difpos := 0;
         w_difant := trunc(w_dtstart - w_dayfirst , 10);
         w_difpos := trunc(w_maxdate - w_dtshut   , 10);
         w_diftot := trunc(w_dtshut  - w_dtstart  , 10);
         if w_difant >= 0 then w_difant := 0; end if;
         if w_difpos >= 0 then w_difpos := 0; end if;
         w_dif := abs(w_difant) + abs(w_difpos);
         w_dispacu := w_dispacu + (w_diftot - w_dif);
      end loop;
      w_return := trunc((w_dispacu*100)/w_dispmax,5);
      return w_return;
   end apura_disponibilidade;

   /*
   ** troca senha de usuários finais
   */
   procedure change_pass(p_k in varchar2, p_opertype in char default 'M', p_user in varchar2 default 'ACB299')
   is
      /*
      ** so troca senha de usuarios que estao cadastrados na D5A
      ** so executar depois da carga dos dados pela stp_sox00001_coleta
      */

      w_subject      varchar2(4000) := 'Política de Segurança de TI - Alteração de Senha de Acesso a Bancos de Dados Oracle - Sistemas Legados.';
      w_sqll         varchar2(500);
      w_cuser        number;
      w_userexist    number;
      w_euser        varchar2(250);
      pup_opertype   char;
      pup_user       varchar2(50);

      /*
      ** variaveis para envio de email
      */

      cursor c_db_link is
         select * from sarbox_instance
         where  upper(search) = 'Y' and upper(type) = 'P';

      cursor c_username is
             select distinct su.username, d5aendin
             from   sarbox_instance_user su,
                    d5acadut             d5,
                    sarbox_instance      si
             where  upper(trim(d5aidred)) = upper(su.username)
             and    d5aendin       is not null
             and    (su.status   <> 'LOCKED' and su.dropped = 'NO')
             and    username not like '70%'
             and    su.instance = si.instance
             and    si.type = 'P'
             and    si.search = 'Y'
             and    not exists (select 1 from pcsox.sarbox_troca_log tint where tint.username = su.username and mensagem = '06 - Enviando nota para o usuário. Operação terminada com sucesso.' and trunc(dttroca) = trunc(sysdate))
             group  by su.username, d5aendin,su.status,su.dropped
             order  by su.username;

      cursor c_userinstance (p_user in varchar2) is
             select siu.instance
             from   sarbox_instance_user siu,
                    sarbox_instance      si
             where  username = p_user
             and    siu.instance <> 'ORAPMVS'
             and    dropped = 'NO'
             and    siu.instance = si.instance
             and    type = 'P'
             and    si.search = 'Y'
             order  by siu.instance;

   procedure send_email
      (  w_subject      varchar2,
         w_to           varchar2,
         w_message      varchar2
      ) as
   begin
      utl_smtp.helo(w_mailconn, w_mailhost);
      utl_smtp.mail(w_mailconn, w_from);

      if w_to = 'ABDACC' then
         utl_smtp.rcpt(w_mailconn, 'l-abdac@vale.com');
      else
         utl_smtp.rcpt(w_mailconn, w_to);
      end if;

      utl_smtp.open_data(w_mailconn);
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date: '||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From: '||'SARBOX'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To: ' ||w_to||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject: '||w_subject||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(w_message||w_crlf));
      utl_smtp.close_data(w_mailconn);

   end send_email;

   function fct_monta_mensagem
      (  w_pass   in varchar2,
         w_usert  in varchar2,
         msg_type in char
      ) return varchar as
      w_msgmonta   varchar2(4000);
   begin
      /*
      ** monta a mensagem do email
      */
      if (msg_type = 'A') or (msg_type = 'S') then
         w_msgmonta :=               'Prezado(a).'                                                                                                    ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Em atendimento à '||chr(34)||'Política de Segurança e Utilização de Tecnologia da Informação'||chr(34)||' e' ||chr(10);
         w_msgmonta := w_msgmonta || '   seguindo as '||chr(34)||'Regras para Uso de Senhas'||chr(34)||', informamos que sua senha de acesso direto'  ||chr(10);
         w_msgmonta := w_msgmonta || '   aos bancos de dados Oracle foi alterada.'                                                                    ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Sua nova senha é: '||chr(34)||w_pass||chr(34)                                                                ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Lembre que a guarda e uso desta senha é de sua responsabilidade.'                                            ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Exemplos de aplicativos no uso destas senhas:'                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   - Impromptu,'                                                                                                ||chr(10);
         w_msgmonta := w_msgmonta || '   - SGDI,'                                                                                                     ||chr(10);
         w_msgmonta := w_msgmonta || '   - Nautilus,'                                                                                                 ||chr(10);
         w_msgmonta := w_msgmonta || '   - Sistemas da Docenave,'                                                                                     ||chr(10);
         w_msgmonta := w_msgmonta || '   - Contmex,'                                                                                                  ||chr(10);
         w_msgmonta := w_msgmonta || '   - Quality,'                                                                                                  ||chr(10);
         w_msgmonta := w_msgmonta || '   - Argis,'                                                                                                    ||chr(10);
         w_msgmonta := w_msgmonta || '   - Etc'                                                                                                       ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Esta senha atende apenas aos sistemas legados e não cobre o sistema Oracle ERP.'                             ||chr(10);
         w_msgmonta := w_msgmonta || '   Caso tente conectar com a senha errada mais de 3(três) vezes sua chave será'                                 ||chr(10);
         w_msgmonta := w_msgmonta || '   bloqueada durante 15 minutos, aguarde pois a chave será liberada automaticamente'                            ||chr(10);
         w_msgmonta := w_msgmonta || '   após este intervalo. '                                                                                       ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Favor não abrir chamado durante este intervalo.'                                                             ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Está é uma mensagem automática. Favor não responder.'                                                        ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || 'Sds,'                                                                                                           ||chr(10);
         w_msgmonta := w_msgmonta || 'Departamento de Tecnologia da Informação'                                                                       ||chr(10);
         w_msgmonta := w_msgmonta || 'Companhia Vale do Rio Doce.'                                                                                    ||chr(10);
      else
         w_msgmonta :=               'Todos(as).'                                                                                                     ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Em atendimento à '||chr(34)||'Política de Segurança e Utilização de Tecnologia da Informação'||chr(34)||' e' ||chr(10);
         w_msgmonta := w_msgmonta || '   seguindo as '||chr(34)||'Regras para Uso de Senhas'||chr(34)||', informamos que a senha de acesso direto'     ||chr(10);
         w_msgmonta := w_msgmonta || '   aos bancos de dados Oracle foi alterada.'                                                                    ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Login: '||chr(34)||w_usert||chr(34)                                                                          ||chr(10);
         w_msgmonta := w_msgmonta || '   Senha: '||chr(34)||w_pass||chr(34)                                                                           ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || '   Está é uma mensagem automática. Favor não responder.'                                                        ||chr(10);
         w_msgmonta := w_msgmonta || ''                                                                                                               ||chr(10);
         w_msgmonta := w_msgmonta || 'Sds,'                                                                                                           ||chr(10);
         w_msgmonta := w_msgmonta || 'Departamento de Tecnologia da Informação'                                                                       ||chr(10);
         w_msgmonta := w_msgmonta || 'Companhia Vale do Rio Doce.'                                                                                    ||chr(10);
      end if;

      return w_msgmonta;

   end fct_monta_mensagem;

   procedure proc_troca_senha
      (  w_user in varchar2,
         w_send in varchar2,
         msg_type in char
      ) as
      w_message      varchar2(4000);
      w_password     varchar2(50);
      w_passwordc    varchar2(100);
      w_sql          varchar2(500);
      w_erro         boolean;
      w_msgerro      varchar2(4000);
      w_trocou       boolean;
   begin
      insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
           values (sysdate, w_user, '', '', '01 - Iniciando troca de senha.', '');
      w_erro     := false;
      w_trocou   := false;
      w_password := '';
      /*
      ** gera a nova senha para o usuario
      */
      w_password  := pak_sox00001.gs;
      w_passwordc := pak_sox00001.c(p_k, w_password);
      insert into sarbox_user_password (username, dtgeracao, password, userexec, terminal, type) values (w_user, sysdate, w_passwordc, upper(user), userenv('terminal'), 'P');
      insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
           values (sysdate, w_user, '', w_passwordc, '02 - Senha gerada/gravada na tabela de senhas.', '');

      w_message := fct_monta_mensagem (w_password, w_user, msg_type);

      insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
           values (sysdate, w_user, '', w_passwordc, '03 - Iniciando loop para troca de senha nas instances.', '');
      for r_userinstance in c_userinstance(w_user)
      loop
         w_trocou := true;
         begin
            /*
            ** todas as instances do usuario
            */
            w_sql := 'call pcsox.stp_sarbox_alterpass@'||r_userinstance.instance||'_sarbox_cp'||'('||chr(39)||w_user||chr(39)||', '||chr(39)||w_password||chr(39)||')';
            execute immediate w_sql;
            insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
                 values (sysdate, w_user, r_userinstance.instance, w_passwordc, '04 - Senha Alterada com sucesso em '||r_userinstance.instance||'.', null);
         exception
            when others then
               w_erro := true;
               w_msgerro := substr(sqlerrm, 1, 4000);
               insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
                    values (sysdate, w_user, r_userinstance.instance, w_passwordc, '04 - ERRO - Senha não foi alterada em '||r_userinstance.instance||'.', w_msgerro);
         end;
      end loop;

      insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
           values (sysdate, w_user, '', w_passwordc, '05 - Finalizando loop para troca de senha nas instances.', '');
      if (w_erro = false) and (w_trocou = true) then

         send_email(w_subject, w_send, w_message);

         insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
              values (sysdate, w_user, '', w_passwordc, '06 - Enviando nota para o usuário. Operação terminada com sucesso.', '');
         commit;
      else
         insert into sarbox_troca_log(dttroca, username, instance, password, mensagem, erro)
              values (sysdate, w_user, '', w_passwordc, '06 - ERRO - Nota não enviada problema com a troca de senha. Operação terminada sem sucesso.', '');
      end if;
      commit;

   end proc_troca_senha;

   begin

      /*
      ** transforma para upper
      */
      pup_opertype  := upper(p_opertype);
      pup_user      := upper(p_user);

      /*
      ** abre conexao com o servidor de email
      */
      w_mailconn := utl_smtp.open_connection(w_mailhost, 25);

      /*
      ** criar db_links
      */
      for r_db_link in c_db_link
      loop
         begin
            w_sqll := 'create database link '||r_db_link.instance||'_sarbox_cp '||pak_sox00001.ctv(w_ws)||' using '||chr(39)||r_db_link.instance||chr(39);
            execute immediate (w_sqll);
         exception
            when others then null;
         end;
      end loop;

      /*
      ** todos os usuários com email se for do tipo automatico
      */
      if pup_opertype  = 'A' then
         for r_username in c_username
         loop
            --dbms_output.put_line('P01 '|| p_opertype || '   -   ' || r_username.username);
            proc_troca_senha(r_username.username, r_username.d5aendin, 'A');
         end loop;
      end if;

      /*
      ** somente para o usuário informado ou a ABD
      */
      w_cuser     := 0;
      w_userexist := 0;
      if pup_opertype  = 'M' then
         /*
         ** se o usuário existe na sarbox_instance_user
         */
         select count(1)
         into   w_userexist
         from   sarbox_instance_user
         where  upper(username) = pup_user;

         /*
         ** se o usuário esta na tabela da CVRD
         */
         begin
            select count(1)
            ,      d5aendin
            into   w_cuser
            ,      w_euser
            from   d5acadut
            where  upper(trim(d5aidred)) = pup_user
            group  by d5aendin;
         exception
            when no_data_found then
               w_cuser := 0;
               w_euser := '';
         end;

         if w_userexist <> 0 then
            if w_cuser <> 0 then
               --dbms_output.put_line('P02 '|| pup_opertype || '   -   ' || pup_user);
               proc_troca_senha(pup_user, w_euser, 'S');
            else
               --dbms_output.put_line('P03 '|| pup_opertype || '   -   ' || pup_user);
               proc_troca_senha(pup_user, 'ABDACC', 'M');
            end if;
         else
            --dbms_output.put_line('P04 '|| pup_opertype || '   -   ' || pup_user);
            raise_application_error(-20001, 'Usuário não cadastrado na tabelas SARBOX_INSTANCE_USER.', false);
         end if;
      end if;

      /*
      ** se nao for nenhuma das opcoes aceitas
      */
      if (pup_opertype <> 'M') and (pup_opertype <> 'A') then
         raise_application_error(-20002, 'Operação não permitida. Só é permitido: A - automatico e M - Manual.', false);
      end if;

      /*
      ** excluir db_links
      */
      for r_db_link in c_db_link
      loop
         begin
            w_sqll := 'ALTER SESSION CLOSE DATABASE LINK '||r_db_link.instance||'_sarbox_cp';
            execute immediate (w_sqll);
            w_sqll := 'drop database link '||r_db_link.instance||'_sarbox_cp';
            execute immediate (w_sqll);
         exception
            when others then
               if sqlcode = -2081 then
                  w_sqll := 'DROP DATABASE LINK '||r_db_link.instance||'_sarbox_cp';
                  execute immediate (w_sqll);
               else
                  null;
               end if;
         end;
      end loop;

      /*
      ** fecha conexao com o servidor de email
      */
      utl_smtp.quit(w_mailconn);
   end change_pass;


   /*
   ** excluir usuários ser registro de login a mais de 180 dias
   */
   procedure drop_user
   as
      /*
      ** Exclusão de usuários que nao se conectaram no oracle a mais de 180 dias
      */
      cursor c_db_link is
         select * from sarbox_instance
         where  upper(search) = 'Y'
         and upper(type) = 'P';

      cursor c_username is
        select distinct su.username, su.instance
        from   sarbox_instance_user su
        ,      d5acadut             d5
        ,      sarbox_instance      si
        where  upper(trim(d5aidred)) = upper(su.username)
        and    su.dropped     = 'NO'
        and    su.owner       = 'NO'
        and    su.last_logon  is not null
        and    d5aendin       is not null
        and    si.instance    = su.instance
        and    upper(si.type) = 'P'
        and    si.search = 'Y'
        and    su.username not in (select su.username
                             from sarbox_instance_user su
                             where su.last_logon >= (sysdate - 180))
        order  by su.username;

      w_sql    varchar2(4000);
      w_osuser v$session.osuser%type;
   begin
      --
      -- indentifica informacoes da sessão
      --
      --select      upper(t1.osuser)
      --   into     w_osuser
      --   from     v$session   t1
      --   where    t1.audsid = userenv('sessionid');

      /*
      ** criar db_links
      */
      for r_db_link in c_db_link
      loop
         begin
            w_sql := 'create database link '||r_db_link.instance||'_dropuser '||pak_sox00001.ctv(w_ws)||' using '||chr(39)||r_db_link.instance||chr(39);
            execute immediate w_sql;
         exception
            when others then null;
         end;
      end loop;

      for r_username in c_username
      loop
         begin
            w_sql := 'call pcsox.prc_del_user@'||r_username.instance||'_dropuser'||'('||chr(39)||r_username.username||chr(39)||')';
            execute immediate w_sql;
            insert into SARBOX_DROPUSER_LOG values (r_username.instance,r_username.username,sysdate,'ORACLE');
            commit;
         exception
            when others then null;
         end;
      end loop;

      /*
      ** excluir db_links
      */
      for r_db_link in c_db_link
      loop
         begin
            w_sql := 'drop database link '||r_db_link.instance||'_dropuser';
            execute immediate w_sql;
         exception
            when others then null;
         end;
      end loop;
   end drop_user;

   procedure limpa_particoes(p_nome_tabela in varchar2)
   is
      NUM_PART_MANTIDAS constant integer := 3;
      NUM_PART_TRUNCADAS constant integer := 1;
      DIA_LIMPEZA constant integer := 1;
      PREFIXO_PART constant char(1) := 'P';
      FORMATO_DT_PART constant char(6) := 'YYYYMM';
      TBSP_DEF constant user_tablespaces.tablespace_name%type := 'D3SOX01T';

      data_atual date := trunc(current_date);
      dt_part_drop date := add_months(data_atual, -NUM_PART_MANTIDAS);
      dt_ult_part date;
      
      nome_particao_drop user_tab_partitions.partition_name%type;
      nome_particao_criada user_tab_partitions.partition_name%type;

      sql_drop_part varchar2(200);
      sql_cria_part varchar2(200);
   begin
      if extract(day from data_atual) <> DIA_LIMPEZA then
         return;
      end if;
      
      nome_particao_drop := PREFIXO_PART||to_char(dt_part_drop, FORMATO_DT_PART);
      sql_drop_part := 'ALTER TABLE '||p_nome_tabela||' DROP PARTITION '||nome_particao_drop;
      begin
         execute immediate sql_drop_part;
      exception
         when others then
            null; -- Erros na limpeza de particoes inexistentes podem ser ignoradas
      end;
      
      select add_months(to_date(substr(max(partition_name), -6, 6), 'YYYYMM'), 1)
      into dt_ult_part
      from user_tab_partitions
      where table_name = 'SARBOX_TOP_QUERIES_TUNING';
      nome_particao_criada := PREFIXO_PART||to_char(dt_ult_part, FORMATO_DT_PART);
      
      sql_cria_part := 'ALTER TABLE '||p_nome_tabela||' ADD PARTITION '||nome_particao_criada
            ||' VALUES LESS THAN(TO_DATE('''||
            to_char(add_months(dt_ult_part, 1), FORMATO_DT_PART)||''', '''||FORMATO_DT_PART||''')) tablespace '||TBSP_DEF;
      execute immediate sql_cria_part;
   end limpa_particoes;

   /**
     * Procedure de coleta de principais queries
     * Lucas Pimentel Lellis
     *
     */
   procedure stp_sarbox_inst_top_qry_tun(p_dblink in varchar2) is
         w_sql       varchar2(400);
   begin
         w_sql := 'insert into SARBOX_INST_TOP_QUERIES_TUNING'||chr(10)||
                  'select '''||p_dblink||''', dtcollect, sql_id, elapsed_time, exec_cnt, parsing_schema_name, sql_text, tuning_recomm'||chr(10)||
                  'from sarbox_top_queries_tuning@'||p_dblink||'_sarbox'||chr(10)||
                  'where dtcollect >= trunc(sysdate)';
         execute immediate w_sql;
         commit;
   exception
         when dup_val_on_index then
            null;
         when others then
            if (sqlcode = -942) then
               null; -- A tabela nao existe no destino
            end if;
   end stp_sarbox_inst_top_qry_tun;

   procedure carrega_partic_tab(p_instancia in varchar2)
   is
      TAB_SOX_TMP constant user_tables.table_name%type := 'SARBOX_TEMP_INST_TAB_PART';
      FETCH_LIMIT constant integer := 500;
      
      type t_cursor_part is ref cursor;
      c_part t_cursor_part;
      type t_sarbox_temp_inst_tab_part is table of SARBOX_TEMP_INST_TAB_PART%rowtype;
      w_sarbox_temp_inst_tab_part t_sarbox_temp_inst_tab_part;
      w_sql_curs_part varchar2(400);
      
      w_tab_part t_tab_info_part := t_tab_info_part();
      w_part_ant t_info_part;
      w_high_value_tmp date;
      w_sql_date varchar2(200);
      w_cnt number := 0;
   begin
      execute immediate 'truncate table '||TAB_SOX_TMP;
      w_sql_curs_part := 'select tp.table_owner, tp.table_name, tp.partition_name, tp.high_value' ||chr(10)||
               'from dba_tab_partitions@'||p_instancia||'_sarbox tp'||chr(10)||
               'join dba_part_tables@'||p_instancia||'_sarbox pt on tp.table_owner = pt.owner and tp.table_name = pt.table_name' ||chr(10)||
               'where pt.partitioning_type in (''LIST'',''RANGE'')';
      
      /* Carrega tabela temporaria com as particoes da origem */
      open c_part for w_sql_curs_part;
      loop
         fetch c_part
         bulk collect into w_sarbox_temp_inst_tab_part limit FETCH_LIMIT;
         
         forall i in w_sarbox_temp_inst_tab_part.first..w_sarbox_temp_inst_tab_part.last
            insert into SARBOX_TEMP_INST_TAB_PART
            values w_sarbox_temp_inst_tab_part(i);
         
         exit when w_sarbox_temp_inst_tab_part.count = 0;
       end loop;
      commit;
      close c_part;
      
      /* Carrega tabela em memoria com as particoes e respectivas datas */
      w_part_ant := t_info_part(' ', ' ', ' ', null);
      for r_part in (select table_owner, table_name, partition_name, high_value 
                     from SARBOX_TEMP_INST_TAB_PART
                     order by 1, 2) loop
         begin        
            w_high_value_tmp := null;
            if instr(upper(r_part.high_value), 'TO_DATE') > 0 then
               w_sql_date := 'begin :high_value := '||r_part.high_value||'; end;';
               execute immediate w_sql_date using out w_high_value_tmp;
            elsif regexp_like(r_part.high_value, '^[[:digit:]]{6}$') and (instr(r_part.high_value, '9999') = 0)then
               w_high_value_tmp := to_date(r_part.high_value, 'YYYYMM'); -- Excecao do FPW na AVT015
            end if;

            if w_high_value_tmp is not null then
               if (r_part.table_owner <> w_part_ant.owner) or (r_part.table_name <> w_part_ant.table_name) then
                  w_cnt := w_cnt + 1;
                  w_tab_part.extend;
                  w_tab_part(w_cnt) := t_info_part(r_part.table_owner, r_part.table_name, null, null);
                  w_part_ant := w_tab_part(w_cnt);
               end if;

               if (w_tab_part(w_cnt).high_value is null) or (w_tab_part(w_cnt).high_value < w_high_value_tmp) then
                  w_tab_part(w_cnt).partition_name := r_part.partition_name;
                  w_tab_part(w_cnt).high_value := w_high_value_tmp;
               end if;
            end if;
        exception
            when others then
               if sqlcode = -6550 then
                  null; -- Erros de conversao de data type podem ser ignorados
               end if;
        end;
      end loop;
      
      update sarbox_instance_tab_part
      set is_last_partition = 'NO'
      where instance = upper(p_instancia);
      merge into sarbox_instance_tab_part tp
         using table(w_tab_part) tmp_tab
         on (tp.instance = upper(p_instancia) and tp.table_owner = tmp_tab.owner and tp.table_name = tmp_tab.table_name and tp.partition_name = tmp_tab.partition_name)
        when matched then
         update
            set tp.high_value = tmp_tab.high_value, is_last_partition = 'YES'
        when not matched then
         insert (INSTANCE, TABLE_OWNER, TABLE_NAME, PARTITION_NAME, HIGH_VALUE, IS_LAST_PARTITION)
         values(upper(p_instancia), tmp_tab.owner, tmp_tab.table_name, tmp_tab.partition_name, tmp_tab.high_value, 'YES');
      commit;
      
   end carrega_partic_tab;
   
   
   procedure verifica_termino_carga(p_instance in varchar2 default '%', p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is
      w_erro_carga number := 0;
      w_printcabec number := 0;
   begin

      /*
      ** faz a verificação do termino da carga
      */
      select count(*)
      into   w_erro_carga
      from   sarbox_instance
      where  upper(search) = 'Y'
      and    notify like upper(p_notify)
      and    ((status = 'NOK') or (startup_time >= trunc(sysdate-1)+1/24) or (server_instances <> server_instances_active) or (file_autoextensible <> 0)) and instance <> 'ORADMVS' and upper(instance) like upper('%'||p_instance||'%');

      if w_erro_carga <> 0 then
         /* ocorreu erro na carga - irá enviar email*/
         w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
         utl_smtp.helo(w_mailconn, w_mailhost);
         utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
         if p_email is null then
            utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
            utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
         else
            utl_smtp.rcpt(w_mailconn, p_email);
         end if;

         utl_smtp.open_data(w_mailconn);
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'COLETA SARBOX - Erro no processo de coleta'||w_crlf));
         -- problema na carga
         w_printcabec := 0;
         for r_coleta_erro in (select instance, errorm, rownum from sarbox_instance where  upper(search) = 'Y' and status = 'NOK' and notify like upper(p_notify))
         loop
            if r_coleta_erro.rownum = 1 then
               w_printcabec := 1;
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentaram falhas durante o processo de coleta:'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - '||r_coleta_erro.instance||' - ERRO: '||r_coleta_erro.errorm||w_crlf));
         end loop;

         if w_printcabec = 1 then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Maiores detalhes na entidade SARBOX_INSTANCE.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Para a(s) instance(s) acima as informações estão inconsistentes.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - não utilizar a procedure da package pak_sox00001.CHANGE_PASS;'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - levantamentos usando as tabelas do PCSOX estarão inconsistentes.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         end if;

         -- instances com startup
         for r_startup in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||rpad(nvl(to_char(startup_time, 'dd/mm/yyyy hh24:mi:ss'), ' '),22) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and startup_time >= trunc(sysdate-1)+1/24 and instance <> 'ORADMVS' and notify like upper(p_notify))
         loop
            if r_startup.rownum = 1 then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) foram reiniciadas após '||to_char(trunc(sysdate-1)+1/24, 'dd/mm/yyyy hh24:mi:ss') ||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||rpad(nvl('Startup Time', ' '),22)||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ----------------------'||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_startup.linhalog||w_crlf));
         end loop;

         -- instances com indisponibilidade de no
         for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(server_instances, 10)||' '||lpad(server_instances_active, 11) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and server_instances <> server_instances_active and instance <> 'ORADMVS' and notify like upper(p_notify))
         loop
            if r_norac.rownum = 1 then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam indisponibilidade de nó RAC:'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total Inst', 10)||' '||lpad('Active Inst', 11)||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ---------- -----------'||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
         end loop;

         -- instances com files em AUTOEXTENSIBLE=YES
         for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(file_autoextensible, 22) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and file_autoextensible <> 0 and notify like upper(p_notify))
         loop
            if r_norac.rownum = 1 then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam arquivos AUTOEXTENSIBLE=YES:'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total AUTOEXTEND ON', 22)||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ----------------------'||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
         end loop;

         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;
   end verifica_termino_carga;

   function converte_dias_segundos(p_dias in number) return number
   is
   begin
      return p_dias * 24 * 60 * 60;
   end converte_dias_segundos;
   
   /* Procedure que registra um alert para callback de um job - Auxiliar de execucao_jobs_paralelo */
   procedure registra_alert_job(p_nome_job in varchar2, p_arr_alerts in out nocopy t_array_alerts, p_arr_sid_alert in out nocopy t_array_sid_alert)
   is
   begin
      dbms_alert.register(p_nome_job);
      p_arr_sid_alert.extend;
      select sid
      into p_arr_sid_alert(p_arr_sid_alert.last)
      from sys.dbms_alert_info
      where name = p_nome_job;
      
      p_arr_alerts(p_nome_job) := 1; /* Marca que ha um alert para um determinado job */
   end registra_alert_job;
   
   /* Procedure que limpa um job e o respectivo Alert registrado - Auxiliar de execucao_jobs_paralelo */
   procedure remove_job(p_job_name in varchar2, p_arr_alerts in out nocopy t_array_alerts)
   is
   begin
      p_arr_alerts.delete(p_job_name);
      dbms_alert.remove(p_job_name);
      begin
         dbms_scheduler.stop_job(p_job_name, true);
         dbms_scheduler.drop_job(p_job_name, true);
      exception when others then
         null; -- erros na remocao de jobs podem ser ignorados neste ponto
      end;
   end remove_job;

   /* Procedure que executa em paralelo uma determinada lista de jobs */
   procedure execucao_jobs_paralelo(p_lista_jobs in t_lista_jobs, p_threshold_total_seg in number, p_threshold_job_seg in number, p_grau_paralelo in number default 10,
                              p_longops_op_name in varchar2 default null, p_longops_tgt_desc in varchar2 default null, p_longops_unit in varchar2 default null)
   is
      PREFIXO_ALERT_PIPE constant varchar2(10) := 'ORA$ALERT$';
   
      w_num_jobs_sim number := 0;
      w_tempo_restante_job number := 0;
      w_dt_ini_job_mais_antigo date := null;
      w_data_inicial date := null;
      w_tempo_gasto number := 0;
      w_next_job pls_integer;
      
      
      /* variaveis para dbms_alert e pipes */
      w_message varchar2(4000);
      w_status integer;
      w_name varchar2(4000);
      w_pipe_ret_code integer;
      w_arr_alerts t_array_alerts;
      w_arr_sid_alert t_array_sid_alert := t_array_sid_alert();
      
      /* variaveis para longops */
      w_lgopsindex      number;
      w_internalstatus  number;
      w_loopreg         number := 0; -- avanco
      
      procedure limpa_jobs
      is
      begin
         for r_jobs in (select job_name
                          from user_scheduler_jobs 
                         where job_name in (select column_value from table(p_lista_jobs))) loop
            begin
               dbms_scheduler.stop_job(r_jobs.job_name, true);
            exception when others then
               null;  -- erros na interrupcao de jobs podem ser ignorados neste ponto
            end;
            begin
               dbms_scheduler.drop_job(r_jobs.job_name, true);
            exception when others then
               null; -- erros na remocao de jobs podem ser ignorados neste ponto
            end;
            end loop;   
      end limpa_jobs;
      
      procedure limpa_alerts
      is
      begin
         for r_alert in (select name from sys.dbms_alert_info where name in (select column_value from table(p_lista_jobs))) loop
            dbms_alert.register(r_alert.name);
         end loop;  
         dbms_alert.removeall;
         commit;
      end limpa_alerts;
      
   begin
      if p_lista_jobs.count = 0 then
         return;
      end if;
   
      limpa_alerts;
      
      if (p_longops_tgt_desc is not null) or (trim(p_longops_tgt_desc) <> '') then
         -- inicializa a linha longops
         w_lgopsindex := dbms_application_info.set_session_longops_nohint;

         -- inicializa a operacao na linha da longops
         dbms_application_info.set_session_longops(
            rindex     => w_lgopsindex,
            slno       => w_internalstatus,
            op_name    => p_longops_op_name,
            sofar      => w_loopreg,
            totalwork  => p_lista_jobs.count,
            target_desc=> p_longops_tgt_desc,
            units      => p_longops_unit);
      end if;
      
      w_num_jobs_sim := p_grau_paralelo;
      if w_num_jobs_sim > p_lista_jobs.count then
         w_num_jobs_sim := p_lista_jobs.count;
      end if;
      for i in 1..w_num_jobs_sim loop
         registra_alert_job(p_lista_jobs(i), w_arr_alerts, w_arr_sid_alert);
         dbms_scheduler.enable(p_lista_jobs(i));
      end loop;
      
      w_next_job := p_grau_paralelo + 1;
      
      while w_arr_alerts.count > 0 loop
         select min(last_start_date)
         into w_dt_ini_job_mais_antigo
         from user_scheduler_jobs
         where job_name in (select column_value from table(p_lista_jobs))
         and last_start_date is not null
         and state not in ('COMPLETED','SUCCEEDED','DISABLED');
      
         w_tempo_gasto := converte_dias_segundos(current_date - w_data_inicial);
         if w_tempo_gasto > p_threshold_total_seg then
            for r_job in (select job_name from user_scheduler_jobs where job_name in (select column_value from table(p_lista_jobs))) loop
               remove_job(r_job.job_name, w_arr_alerts);
            end loop;
            dbms_alert.removeall;
            commit;
            exit;
         end if;
         
         w_tempo_gasto := converte_dias_segundos(current_date - w_data_inicial);
         w_tempo_restante_job := p_threshold_job_seg - (converte_dias_segundos(current_date - w_dt_ini_job_mais_antigo));
         if w_tempo_restante_job is null then
            w_tempo_restante_job := p_threshold_job_seg;
         end if;
         
         if w_tempo_restante_job <= 0 then
            w_tempo_restante_job := 1; -- timeout minimo
         elsif w_tempo_restante_job > (p_threshold_total_seg - w_tempo_gasto) then
            w_tempo_restante_job := p_threshold_total_seg - w_tempo_gasto;
         end if;
      
         dbms_alert.waitany(w_name, w_message, w_status, w_tempo_restante_job);
         if w_status = 0 then
            w_arr_alerts.delete(w_name);
            dbms_alert.remove(w_name);
            w_loopreg := w_loopreg + 1;
            dbms_application_info.set_session_longops(rindex=>w_lgopsindex, slno=>w_internalstatus, sofar=>w_loopreg, totalwork=>p_lista_jobs.count);
            commit;
            if w_next_job <= p_lista_jobs.last then
               registra_alert_job(p_lista_jobs(w_next_job), w_arr_alerts, w_arr_sid_alert);
               dbms_scheduler.enable(p_lista_jobs(w_next_job));
               w_next_job := w_next_job + 1;
            end if;
         else
            for r_job in (select job_name
                            from user_scheduler_jobs 
                           where job_name in (select column_value from table(p_lista_jobs))
                             and (current_date - start_date) > numtodsinterval(w_tempo_restante_job, 'SECOND')) loop
               remove_job(r_job.job_name, w_arr_alerts);
               w_loopreg := w_loopreg + 1;
               if w_next_job <= p_lista_jobs.last then
                  registra_alert_job(p_lista_jobs(w_next_job), w_arr_alerts, w_arr_sid_alert);
                  dbms_scheduler.enable(p_lista_jobs(w_next_job));
                  w_next_job := w_next_job + 1;
               end if;
            end loop;
            dbms_application_info.set_session_longops(rindex=>w_lgopsindex, slno=>w_internalstatus, sofar=>w_loopreg, totalwork=>p_lista_jobs.count);
         end if;
      
      end loop;
      
      limpa_jobs;
      limpa_alerts;
      
      /* How to Remove Implicit Pipes Created With Dbms_Alert? (Doc ID 1540181.1) */
      for i in w_arr_sid_alert.first..w_arr_sid_alert.last loop
         begin
            w_pipe_ret_code := dbms_pipe.remove_pipe(PREFIXO_ALERT_PIPE||w_arr_sid_alert(i));
         exception
            when others then -- pipes ja excluidos podem ser ignorados
               null;
         end;
      end loop;
      
      commit;
   end execucao_jobs_paralelo;
 
   /* Procedure de coleta de todas as instancias com search = Y */
   procedure coleta_sarbox_global
   is      
      NUM_JOBS_SIM_DEF constant pls_integer := 10;
      THRESHOLD_TOTAL constant number := 4 * 60 * 60; -- Em segundos
      THRESHOLD_PADRAO_JOB constant number := 30 * 60; -- Em segundos
      PREFIXO_JOB constant varchar2(11) := 'SOX_COLETA_';
      
      type t_array_instances is table of varchar2(30) index by pls_integer;
      w_arr_instances t_array_instances;
      
      w_nome_job user_scheduler_jobs.job_name%type;
      w_lista_jobs t_lista_jobs := t_lista_jobs();
      
      /* variaveis para controle de locks */
      w_lockhandle varchar2(4000);
      w_lock_status pls_integer;
   begin
      dbms_lock.allocate_unique(PREFIXO_JOB, w_lockhandle);
      w_lock_status := dbms_lock.request(w_lockhandle, DBMS_LOCK.X_MODE, 0, false);
      if w_lock_status <> 0 then
         raise_application_error(-20001, 'Já há coleta em execução');
      end if;
      
      for r_jobs in (select job_name from user_scheduler_jobs where job_name like PREFIXO_JOB||'%') loop
         begin
            dbms_scheduler.stop_job(r_jobs.job_name, true);
         exception when others then
            null;  -- erros na interrupcao de jobs podem ser ignorados neste ponto
         end;
         begin
            dbms_scheduler.drop_job(r_jobs.job_name, true);
         exception when others then
            null; -- erros na remocao de jobs podem ser ignorados neste ponto
         end;
      end loop;
      
      select instance
      bulk collect into w_arr_instances
      from sarbox_instance
      where search = 'Y'
      order by priority;
      
      update sarbox_instance
      set file_autoextensible = 0,
          message = null,
          errorm = null,
          statement = null,
          status = null
      where search = 'Y'
      and (status <> 'OK' or dtcollect < trunc(sysdate));
      commit;
      
      w_lista_jobs.extend(w_arr_instances.count);
      
      for i in w_arr_instances.first..w_arr_instances.last loop
         w_nome_job := PREFIXO_JOB||w_arr_instances(i);
         dbms_scheduler.create_job (
            job_name            => w_nome_job,
            job_type            => 'PLSQL_BLOCK',
            job_action          =>  'begin'||chr(10)||
                                    'sox.coleta_sarbox(p_instance => '''||w_arr_instances(i)||''', p_notify=>''N'');'||chr(10)||
                                    'dbms_alert.signal('''||w_nome_job||''', '''||w_nome_job||''');'||chr(10)||
                                    'commit;'||chr(10)||
                                    'end;',
            number_of_arguments => 0,
            start_date          => current_date,
            enabled             => false,
            auto_drop           => true,
            comments            => 'Coleta Sarbox da instance '||w_arr_instances(i));
         w_lista_jobs(i) := w_nome_job;
      end loop;
      
      execucao_jobs_paralelo(w_lista_jobs, THRESHOLD_TOTAL, THRESHOLD_PADRAO_JOB, NUM_JOBS_SIM_DEF, 'SARBOX - Coleta', 'Instances', 'Instance');
      
      update sarbox_instance
            set status = 'NOK',
                message = to_char(current_date, 'DD/MM/YYYY HH24:MI:SS')||' - Processo abortado devido ao estouro da janela',
                errorm = 'Processo abortado devido ao estouro da janela'
         where search = 'Y'
            and (status is null
                  or status in ('NA', 'WT-OK'));
      commit;
      
      limpa_particoes('SARBOX_INST_TOP_QUERIES_TUNING');
     
      verifica_termino_carga;
      
      w_lock_status := dbms_lock.release(w_lockhandle);
   end coleta_sarbox_global;

   
   
   /*
   ** procedure de coleta de dados
   */
   procedure coleta_sarbox (p_instance in varchar2 default '%', p_full in varchar2 default 'S', p_email in varchar2 default null, p_notify in varchar2 default 'Y', p_debug in boolean default false)
   is
      /* grant select on sys.link$ to operacao */

      w_sql                      varchar2(4000);
      w_linha_log                varchar2(4000);
      w_rows                     number;
      w_sql_owner                varchar2(4000);
      w_bol_owner                varchar2(10);
      w_commit                   number;
      w_erro_message             varchar2(400);
      w_erro_statement           varchar2(400);
      w_erro_carga               number := 0;
      w_printcabec               number := 0;
      w_datetimeproc             date;
      w_sendmailsync             char   := 'N';
      w_pos1                     number;
      w_len1                     number;
      w_instnm                   varchar2(15);
      w_coleta_started           varchar2(30);
      w_coleta_ended             varchar2(30);

      w_tab_priv_detail          varchar2(500);


      /* variaveis para longops */
      w_lgopsindex      number;
      w_internalstatus  number;
      w_cntreg          number;     -- total de registros
      w_loopreg         number :=0; -- avanco

      w_debug_dtstart            varchar2(30) := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
      w_debug_dtend              varchar2(30);
      adddebuginfo               boolean := true;
      w_strmail                  boolean;
      w_posfim                   number;
      w_mailadd                  varchar2(100);

      /* cursor de usuarios */
      w_user_username            sarbox_instance_user.username%type;
      w_user_status              sarbox_instance_user.status%type;
      w_user_owner               sarbox_instance_user.owner%type;
      w_user_owner_link          sarbox_instance_user.owner_dblink%type;
      w_user_profile             sarbox_instance_user.profile%type;
      w_user_ldate               sarbox_instance_user.lock_date%type;
      w_user_password            sarbox_user_password.password%type;
      w_expiry_date              sarbox_instance_user.expiry_date%type;
      w_tbs_default              sarbox_instance_user.default_tablespace%type;
      w_tbs_temporary            sarbox_instance_user.temporary_tablespace%type;
      w_last_logon               date;
      w_user_created             date;

      /* cursor de usuários da sys.user$ - reservado */
      w_usr$_user#               sarbox_instance_user$.user#%type;
      w_usr$_name                sarbox_instance_user$.name%type;
      w_usr$_type#               sarbox_instance_user$.type#%type;
      w_usr$_password            sarbox_instance_user$.password%type;
      w_usr$_datats#             sarbox_instance_user$.datats#%type;
      w_usr$_tempts#             sarbox_instance_user$.tempts#%type;
      w_usr$_ctime               sarbox_instance_user$.ctime%type;
      w_usr$_ptime               sarbox_instance_user$.ptime%type;
      w_usr$_exptime             sarbox_instance_user$.exptime%type;
      w_usr$_ltime               sarbox_instance_user$.ltime%type;
      w_usr$_resource$           sarbox_instance_user$.resource$%type;
      w_usr$_audit$              sarbox_instance_user$.audit$%type;
      w_usr$_defrole             sarbox_instance_user$.defrole%type;
      w_usr$_defgrp#             sarbox_instance_user$.defgrp#%type;
      w_usr$_defgrp_seq#         sarbox_instance_user$.defgrp_seq#%type;
      w_usr$_astatus             sarbox_instance_user$.astatus%type;
      w_usr$_lcount              sarbox_instance_user$.lcount%type;
      w_usr$_defschclass         sarbox_instance_user$.defschclass%type;
      w_usr$_ext_username        sarbox_instance_user$.ext_username%type;
      w_usr$_spare1              sarbox_instance_user$.spare1%type;
      w_usr$_spare2              sarbox_instance_user$.spare2%type;
      w_usr$_spare3              sarbox_instance_user$.spare3%type;
      w_usr$_spare4              sarbox_instance_user$.spare4%type;
      w_usr$_spare5              sarbox_instance_user$.spare5%type;
      w_usr$_spare6              sarbox_instance_user$.spare6%type;

      /* cursor de db_links */
      w_link_owner               sarbox_instance_link.owner%type;
      w_link_dblink              sarbox_instance_link.dblink%type;
      w_link_ctime               sarbox_instance_link.ctime%type;
      w_link_host                sarbox_instance_link.host%type;
      w_link_username            sarbox_instance_link.username%type;
      w_link_password            sarbox_instance_link.password%type;
      w_link_flag                sarbox_instance_link.flag%type;
      w_link_authusr             sarbox_instance_link.authusr%type;
      w_link_autphwd             sarbox_instance_link.autphpwd%type;
      w_link_passwordx           sarbox_instance_link.passwordx%type;

      /* cursor de logins */
      w_login_username           sarbox_instance_login.username%type;
      w_login_program            sarbox_instance_login.program%type;
      w_login_userso             sarbox_instance_login.userso%type;
      w_login_machine            sarbox_instance_login.machine%type;

      /* cursor de profiles */
      w_profile_name             sarbox_instance_profile.profile%type;
      w_profile_rname            sarbox_instance_profile.resource_name%type;
      w_profile_rtype            sarbox_instance_profile.resource_type%type;
      w_profile_limit            sarbox_instance_profile.limit%type;

      /* dados da instance */
      w_inst_version             sarbox_instance.version%type;
      w_inst_host                sarbox_instance.hostname%type;
      w_inst_startup             sarbox_instance.startup_time%type;
      w_inst_instnum             sarbox_instance.instance_number%type;
      w_inst_status              sarbox_instance.status%type;
      w_inst_lang                varchar2(100);
      w_inst_terr                varchar2(100);
      w_inst_cs                  varchar2(100);
      w_inst_nls                 varchar2(100);
      w_inst_size                number;
      w_inst_fileauto            number;
      w_inst_sessions_current    sarbox_instance.sessions_current%type;
      w_inst_sessions_highwater  sarbox_instance.sessions_highwater%type;
      w_inst_cpu_count_current   sarbox_instance.cpu_count_current%type;
      w_inst_cpu_count_highwater sarbox_instance.cpu_count_highwater%type;
      w_inst_fixed_size          sarbox_instance.fixed_size%type;
      w_inst_variable_size       sarbox_instance.variable_size%type;
      w_inst_database_buffers    sarbox_instance.database_buffers%type;
      w_inst_redo_buffers        sarbox_instance.redo_buffers%type;
      w_inst_logmode             sarbox_instance.log_mode%type;
      w_inst_nls_length_semantic varchar2(100);
      w_inst_nls_nchar_cs        varchar2(100);

      w_inst_created             sarbox_instance.created%type;
      w_inst_resetlogs_time      sarbox_instance.resetlogs_time%type;
      w_inst_cf_created          sarbox_instance.controlfile_created%type;
      w_inst_cf_time             sarbox_instance.controlfile_time%type;
      w_inst_version_time        sarbox_instance.version_time%type;
      w_inst_platform_id         sarbox_instance.platform_id%type;
      w_inst_platform_name       sarbox_instance.platform_name%type;
      w_inst_rec_incarnation     sarbox_instance.recovery_target_incarnation#%type;
      w_inst_last_incarnation    sarbox_instance.last_open_incarnation#%type;
      w_inst_serverinst          sarbox_instance.server_instances%type;
      w_inst_serverinst_act      sarbox_instance.server_instances_active%type;

      /* informacao para as instances com asm */
      w_inst_asm_name            varchar2(100);
      w_inst_asm_total_mb        number;
      w_inst_asm_free_mb         number;

      /* informação para o fs*/
      w_stg_alocation_type       sarbox_instance_storage.alocation_type%type;
      w_stg_dtcollect            sarbox_instance_storage.dtcollect%type;
      w_stg_mountpoint           sarbox_instance_storage.mountpoint%type;
      w_stg_filesystem           sarbox_instance_storage.filesystem%type;
      w_stg_baloc                sarbox_instance_storage.bytes_aloc%type;
      w_stg_bused                sarbox_instance_storage.bytes_used%type;

      /* cursor de role privs */
      w_rolepriv_grantee         sarbox_instance_rolepriv.grantee%type;
      w_rolepriv_granted_role    sarbox_instance_rolepriv.granted_role%type;
      w_rolepriv_admin_option    sarbox_instance_rolepriv.admin_option%type;
      w_rolepriv_default_role    sarbox_instance_rolepriv.default_role%type;

      /* cursor de tab privs */
      w_tabpriv_grantee          sarbox_instance_tabpriv.grantee%type;
      w_tabpriv_owner            sarbox_instance_tabpriv.owner%type;
      w_tabpriv_table_name       sarbox_instance_tabpriv.table_name%type;
      w_tabpriv_grantor          sarbox_instance_tabpriv.grantor%type;
      w_tabpriv_privilege        sarbox_instance_tabpriv.privilege%type;
      w_tabpriv_grantable        sarbox_instance_tabpriv.grantable%type;
      w_tabpriv_rowid_search     rowid;

      /* cursor sys privs */
      w_syspriv_grantee          sarbox_instance_syspriv.grantee%type;
      w_syspriv_privilege        sarbox_instance_syspriv.privilege%type;
      w_syspriv_admin_option     sarbox_instance_syspriv.admin_option%type;

      /* cursor de roles */
      w_role_role                sarbox_instance_role.role%type;
      w_role_password_required   sarbox_instance_role.password_required%type;

      /* cursor de objects */
      w_object_owner             sarbox_instance_object.owner%type;
      w_object_object_name       sarbox_instance_object.object_name%type;
      w_object_subobject_name    sarbox_instance_object.subobject_name%type;
      w_object_object_id         sarbox_instance_object.object_id%type;
      w_object_data_object_id    sarbox_instance_object.data_object_id%type;
      w_object_object_type       sarbox_instance_object.object_type%type;
      w_object_created           sarbox_instance_object.created%type;
      w_object_last_ddl_time     sarbox_instance_object.last_ddl_time%type;
      w_object_timestamp         sarbox_instance_object.timestamp%type;
      w_object_status            sarbox_instance_object.status%type;
      w_object_temporary         sarbox_instance_object.temporary%type;
      w_object_generated         sarbox_instance_object.generated%type;
      w_object_secondary         sarbox_instance_object.secondary%type;

      /* cursor de parametros */
      w_parameter_name           sarbox_instance_parameter.name%type;
      w_parameter_instid         sarbox_instance_parameter.inst_id%type;
      w_parameter_num            sarbox_instance_parameter.num%type;
      w_parameter_type           sarbox_instance_parameter.type%type;
      w_parameter_value          sarbox_instance_parameter.value%type;
      w_parameter_isdefault      sarbox_instance_parameter.isdefault%type;
      w_parameter_ismodified     sarbox_instance_parameter.ismodified%type;
      w_parameter_isadjusted     sarbox_instance_parameter.isadjusted%type;


      /* cursor de export */
      w_exp_idprc                sarbox_instance_export.id_process%type;
      w_exp_start                sarbox_instance_export.started%type;
      w_exp_end                  sarbox_instance_export.ended%type;
      w_exp_status               sarbox_instance_export.status%type;
      w_filename                 sarbox_instance_export.filename%type;
      w_filesize                 sarbox_instance_export.filesize%type;
      w_message_ora              sarbox_instance_export.message_ora%type;
      w_message_exp              sarbox_instance_export.message_exp%type;

      /* cursor de startup */
      w_start_startup_time       sarbox_instance_startup.startup_time%type;
      w_start_instance_id        sarbox_instance_startup.instance_id%type;
      w_start_instance_name      sarbox_instance_startup.instance_name%type;
      w_start_user_oracle        sarbox_instance_startup.user_oracle%type;
      w_start_user_so            sarbox_instance_startup.user_so%type;
      w_start_terminal           sarbox_instance_startup.terminal%type;
      w_start_operation          sarbox_instance_startup.operation%type;
      w_start_host_name          sarbox_instance_startup.host_name%type;
      w_start_version            sarbox_instance_startup.version%type;
      w_start_status             sarbox_instance_startup.status%type;
      w_start_archiver           sarbox_instance_startup.archiver%type;
      w_start_logins             sarbox_instance_startup.logins%type;
      w_start_database_status    sarbox_instance_startup.database_status%type;
      w_start_archive_mode       sarbox_instance_startup.archive_mode%type;
      w_start_dtstartup          sarbox_instance_startup.dtstartup%type;
      w_start_dtshutdown         sarbox_instance_startup.dtshutdown%type;

      /* cursor de registry */
      w_reg_comp_id              sarbox_instance_registry.comp_id%type;
      w_reg_comp_name            sarbox_instance_registry.comp_name%type;
      w_reg_version              sarbox_instance_registry.version%type;
      w_reg_status               sarbox_instance_registry.status%type;
      w_reg_modified             sarbox_instance_registry.modified%type;
      w_reg_namespace            sarbox_instance_registry.namespace%type;
      w_reg_control              sarbox_instance_registry.control%type;
      w_reg_schema               sarbox_instance_registry.schema%type;
      w_reg_procedure            sarbox_instance_registry.proc%type;
      w_reg_startup              sarbox_instance_registry.startup%type;
      w_reg_parent_id            sarbox_instance_registry.parent_id%type;
      w_reg_other_schemas        sarbox_instance_registry.other_schemas%type;

      /* cursor para tablespaces  */
      w_tbs_name                 sarbox_instance_tablespace.tablespace_name%type;
      w_tbs_dtcollect            sarbox_instance_tablespace.dtcollect%type;
      w_tbs_contents             sarbox_instance_tablespace.contents%type;
      w_tbs_allocation           sarbox_instance_tablespace.allocation_type%type;
      w_tbs_management           sarbox_instance_tablespace.extent_management%type;
      w_tbs_baloc                sarbox_instance_tablespace.bytes_aloc%type;
      w_tbs_bused                sarbox_instance_tablespace.bytes_used%type;

      /* cursor de jobs */
      w_job_job                  sarbox_instance_job.job%type;
      w_job_log_user             sarbox_instance_job.log_user%type;
      w_job_priv_user            sarbox_instance_job.priv_user%type;
      w_job_schema_user          sarbox_instance_job.schema_user%type;
      w_job_last_date            sarbox_instance_job.last_date%type;
      w_job_last_sec             sarbox_instance_job.last_sec%type;
      w_job_this_date            sarbox_instance_job.this_date%type;
      w_job_this_sec             sarbox_instance_job.this_sec%type;
      w_job_next_date            sarbox_instance_job.next_date%type;
      w_job_next_sec             sarbox_instance_job.next_sec%type;
      w_job_total_time           sarbox_instance_job.total_time%type;
      w_job_broken               sarbox_instance_job.broken%type;
      w_job_interval             sarbox_instance_job.interval%type;
      w_job_failures             sarbox_instance_job.failures%type;
      w_job_what                 sarbox_instance_job.what%type;
      w_job_nls_env              sarbox_instance_job.nls_env%type;
      w_job_misc_env             sarbox_instance_job.misc_env%type;
      w_job_instance_id          sarbox_instance_job.instance_id%type;

      /* cursor de mapeamento idm */
      w_idm_instance_source      sarbox_instance_idm.instance_source%type;
      w_idm_connect_string       sarbox_instance_idm.connect_string%type;
      w_idm_priority             sarbox_instance_idm.priority%type;
      w_idm_createuser           sarbox_instance_idm.createuser%type;

      /* cursor para sinônimos  */
      w_syn_owner                sarbox_instance_synonym.owner%type;
      w_syn_synonym_name         sarbox_instance_synonym.synonym_name%type;
      w_syn_table_owner          sarbox_instance_synonym.table_owner%type;
      w_syn_table_name           sarbox_instance_synonym.table_name%type;
      w_syn_db_link              sarbox_instance_synonym.db_link%type;

      /* cursor para snapshots  */
      w_snap_owner               sarbox_instance_snapshot.owner%type;
      w_snap_name                sarbox_instance_snapshot.name%type;
      w_snap_table_name          sarbox_instance_snapshot.table_name%type;
      w_snap_master_view         sarbox_instance_snapshot.master_view%type;
      w_snap_master_owner        sarbox_instance_snapshot.master_owner%type;
      w_snap_master              sarbox_instance_snapshot.master%type;
      w_snap_master_link         sarbox_instance_snapshot.master_link%type;
      w_snap_can_use_log         sarbox_instance_snapshot.can_use_log%type;
      w_snap_updatable           sarbox_instance_snapshot.updatable%type;
      w_snap_refresh_method      sarbox_instance_snapshot.refresh_method%type;
      w_snap_last_refresh        sarbox_instance_snapshot.last_refresh%type;
      w_snap_error               sarbox_instance_snapshot.error%type;
      w_snap_fr_operations       sarbox_instance_snapshot.fr_operations%type;
      w_snap_cr_operations       sarbox_instance_snapshot.cr_operations%type;
      w_snap_type                sarbox_instance_snapshot.type%type;
      w_snap_next                sarbox_instance_snapshot.next%type;
      w_snap_start_with          sarbox_instance_snapshot.start_with%type;
      w_snap_refresh_group       sarbox_instance_snapshot.refresh_group%type;
      w_snap_update_trig         sarbox_instance_snapshot.update_trig%type;
      w_snap_update_log          sarbox_instance_snapshot.update_log%type;
      w_snap_query               sarbox_instance_snapshot.query%type;
      w_snap_master_rollback_seg sarbox_instance_snapshot.master_rollback_seg%type;
      w_snap_status              sarbox_instance_snapshot.status%type;
      w_snap_refresh_mode        sarbox_instance_snapshot.refresh_mode%type;
      w_snap_prebuilt            sarbox_instance_snapshot.prebuilt%type;

      /* cursor para RAC  */
      w_rac_instance_name        sarbox_instance_rac.instance_name%type;
      w_rac_inst_id              sarbox_instance_rac.inst_id%type;
      w_rac_host_name            sarbox_instance_rac.host_name%type;
      w_rac_startup_time         sarbox_instance_rac.startup_time%type;
      w_rac_shutdown_pending     sarbox_instance_rac.shutdown_pending%type;

      /*
      ** variaveis para o cursor
      */
      w_fs_host                  sarbox_instance_fs.hostname%type;
      w_fs_fs                    sarbox_instance_fs.filesystem%type;
      w_fs_mp                    sarbox_instance_fs.mountpoint%type;
      w_fs_sizeb                 sarbox_instance_fs.sizeb%type;
      w_fs_usedb                 sarbox_instance_fs.usedb%type;
      w_fs_freeb                 sarbox_instance_fs.freeb%type;
      w_fs_pct                   sarbox_instance_fs.pctuse%type;

      type rc is ref cursor;
      c_users        rc;
      c_user$        rc;
      c_links        rc;
      c_login        rc;
      c_profiles     rc;
      c_roleprivs    rc;
      c_tabprivs     rc;
      c_roles        rc;
      c_sysprivs     rc;
      c_objects      rc;
      c_parameter    rc;
      c_export       rc;
      c_start        rc;
      c_registry     rc;
      c_tablespace   rc;
      c_mapidm       rc;
      c_job          rc;
      c_storage      rc;
      c_asm          rc;
      c_syn          rc;
      c_snap         rc;
      c_rac          rc;

      cursor c_db_link is
         select * from sarbox_instance
         where  upper(search) = 'Y' and upper(instance) like upper('%'||p_instance||'%')
         order by priority;

   begin
      
      adddebuginfo := p_debug;

      w_coleta_started := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');

      /*
      ** exclui db_links que ficaram perdidos em caso de erro.
      */
      for r_db in (select db_link from user_db_links)
      loop
         begin
            --dbms_output.put_line(r_db.db_link);
            w_sql := 'DROP DATABASE LINK '||r_db.db_link||'_sarbox';
            execute immediate (w_sql);
            w_sql := 'DROP DATABASE LINK '||r_db.db_link||'_sarbox_cp';
            execute immediate (w_sql);
         exception
            when others then null;
         end;
      end loop;

      /*
      ** limpa historico de usário (dtcoleta-30)
      */

      update sarbox_instance
      set    status  = '*******'
      ,      message = 'ATENÇÃO: Instance não contemplada no processo de coleta de informação.'
      ,      errorm =  null
      ,      statement = null
      where  search = 'N'
      and    upper(instance) like upper('%'||p_instance||'%');
      commit;


      for r_atstatus in (select instance, nvl(dtcollect, sysdate) dtcol, status from sarbox_instance where search = 'Y' and upper(instance) like upper('%'||p_instance||'%'))
      loop
         if (r_atstatus.status is null) or (trunc(sysdate) <> trunc(r_atstatus.dtcol)) then
            update sarbox_instance
            set    status  = 'WT-OK'
            ,      message = 'Processo de carga sendo executado. Aguarde processamento.'
            ,      errorm =  null
            ,      statement = null
            where  instance = r_atstatus.instance;
            commit;
         end if;
         if r_atstatus.status  = 'NA' then
            update sarbox_instance
            set    status  = 'NOK'
            ,      message = 'Processo de carga reiniciado, processo indo para instance seguinte.'
            ,      errorm =  null
            ,      statement = null
            where  instance = r_atstatus.instance;
            commit;
         end if;
      end loop;

      for r_exclui in (select rowid from sarbox_instance_user_history where dtcoleta <= sysdate-30)
      loop
         delete sarbox_instance_user_history where rowid = r_exclui.rowid;
      end loop;
      commit;
      
      w_sql := '';
      w_sql := 'truncate table pcsox.sarbox_temp_instance_tabpriv drop storage';
      execute immediate w_sql;
      w_sql := 'truncate table pcsox.sarbox_temp_instance_object drop storage';
      execute immediate w_sql;
      w_sql := 'truncate table pcsox.sarbox_temp_instance_login drop storage';
      execute immediate w_sql;
      w_sql := 'truncate table pcsox.sarbox_temp_instance_rolepriv drop storage';
      execute immediate w_sql;
      w_sql := 'truncate table pcsox.sarbox_temp_instance_syspriv drop storage';
      execute immediate w_sql;
      
      select count(1)
      into   w_cntreg
      from   sarbox_instance
      where  upper(search) = 'Y';

      if p_instance = '%' then
         -- inicializa a linha longops
         w_lgopsindex := dbms_application_info.set_session_longops_nohint;

         -- inicializa a operacao na linha da longops
         dbms_application_info.set_session_longops(
            rindex     => w_lgopsindex,
            slno       => w_internalstatus,
            op_name    => 'SARBOX - Coleta',
            sofar      => w_loopreg,
            totalwork  => w_cntreg,
            target_desc=>'Instances',
            units      =>'Instance');
      end if;
            
      for r_db_link in c_db_link
      loop
         update sarbox_instance set dtcollect = sysdate where instance = r_db_link.instance;
         commit;
         dbms_application_info.set_client_info('SARBOX - Coleta (Instance: '||r_db_link.instance||')');
         if p_instance = '%' then
            w_loopreg := w_loopreg + 1;
            dbms_application_info.set_session_longops(rindex=>w_lgopsindex, slno=>w_internalstatus, sofar=>w_loopreg, totalwork=>w_cntreg);
         end if;
         dbms_application_info.set_action('Instance: '||r_db_link.instance);

         if r_db_link.status = 'WT-OK' then

            w_linha_log := '';
            w_linha_log := to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')||' - ';
            /*
            ** criar db_links
            */
            begin
               w_sql := 'create database link '||r_db_link.instance||'_sarbox '||pak_sox00001.ctv(w_ws)||' using '||chr(39)||r_db_link.connect_string||chr(39);
               execute immediate (w_sql);
            exception
               when others then null;
            end;
            
            if adddebuginfo = true then
               /*
               ** log de execução
               */
               w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
               insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'001 - Criar db_link');
               w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
            end if;

            begin
               /*
               **
               */
               execute immediate 'select version, host_name, startup_time, instance_number from v$instance@'||r_db_link.instance||'_sarbox' into w_inst_version, w_inst_host, w_inst_startup, w_inst_instnum;
               execute immediate 'select sum(bytes)/1024 bytes from (select sum(bytes) bytes from dba_data_files@'||r_db_link.instance||'_sarbox union select sum(bytes) bytes from dba_temp_files@'||r_db_link.instance||'_sarbox union select sum(bytes) bytes from v$log@'||r_db_link.instance||'_sarbox)' into w_inst_size;
               execute immediate 'select sum(cnt) from (select count(*) cnt from dba_data_files@'||r_db_link.instance||'_sarbox where autoextensible = '||chr(39)||'YES'||chr(39)||' union select count(*) cnt from dba_temp_files@'||r_db_link.instance||'_sarbox where autoextensible = '||chr(39)||'YES'||chr(39)||')' into w_inst_fileauto;
               execute immediate 'select value nl from nls_database_parameters@'||r_db_link.instance||'_sarbox where parameter = '||chr(39)||'NLS_LANGUAGE'||chr(39)             into w_inst_lang;
               execute immediate 'select value nt from nls_database_parameters@'||r_db_link.instance||'_sarbox where parameter = '||chr(39)||'NLS_TERRITORY'||chr(39)            into w_inst_terr;
               execute immediate 'select value nc from nls_database_parameters@'||r_db_link.instance||'_sarbox where parameter = '||chr(39)||'NLS_CHARACTERSET'||chr(39)         into w_inst_cs;
               execute immediate 'select value nc from nls_database_parameters@'||r_db_link.instance||'_sarbox where parameter = '||chr(39)||'NLS_NCHAR_CHARACTERSET'||chr(39)   into w_inst_nls_nchar_cs;
               execute immediate 'select value ps from v$parameter@'||r_db_link.instance||'_sarbox where name = '||chr(39)||'parallel_server_instances'||chr(39)                 into w_inst_serverinst;
               execute immediate 'select count(1) cnt from gv$instance@'||r_db_link.instance||'_sarbox'                                                                          into w_inst_serverinst_act;
               execute immediate 'select value nl from v$sga@'||r_db_link.instance||'_sarbox where name = '||chr(39)||'Fixed Size'||chr(39)                                      into w_inst_fixed_size;
               execute immediate 'select value nl from v$sga@'||r_db_link.instance||'_sarbox where name = '||chr(39)||'Variable Size'||chr(39)                                   into w_inst_variable_size;
               execute immediate 'select value nl from v$sga@'||r_db_link.instance||'_sarbox where name = '||chr(39)||'Database Buffers'||chr(39)                                into w_inst_database_buffers;
               execute immediate 'select value nl from v$sga@'||r_db_link.instance||'_sarbox where name = '||chr(39)||'Redo Buffers'||chr(39)                                    into w_inst_redo_buffers;
               execute immediate 'select log_mode from v$database@'||r_db_link.instance||'_sarbox'                                                                               into w_inst_logmode;

               w_inst_sessions_current       := 0;
               w_inst_sessions_highwater     := 0;
               w_inst_cpu_count_current      := 0;
               w_inst_cpu_count_highwater    := 0;
               begin
                  execute immediate 'select sessions_current, sessions_highwater, cpu_count_current, cpu_count_highwater from v$license@'||r_db_link.instance||'_sarbox'      into w_inst_sessions_current, w_inst_sessions_highwater, w_inst_cpu_count_current, w_inst_cpu_count_highwater;
               exception
                  when others then
                  execute immediate 'select sessions_current, sessions_highwater, null ccc, null cch from v$license@'||r_db_link.instance||'_sarbox'      into w_inst_sessions_current, w_inst_sessions_highwater, w_inst_cpu_count_current, w_inst_cpu_count_highwater;
               end;

               begin
                  execute immediate 'select created, resetlogs_time, controlfile_created, controlfile_time, version_time, platform_id, platform_name, recovery_target_incarnation#, last_open_incarnation# from v$database@'||r_db_link.instance||'_sarbox' into w_inst_created, w_inst_resetlogs_time, w_inst_cf_created, w_inst_cf_time, w_inst_version_time, w_inst_platform_id, w_inst_platform_name, w_inst_rec_incarnation, w_inst_last_incarnation;
               exception
                  when others then
                  execute immediate 'select created, resetlogs_time, controlfile_created, controlfile_time, version_time, null pltid, null pltnm, null rti, null loi from v$database@'||r_db_link.instance||'_sarbox' into w_inst_created, w_inst_resetlogs_time, w_inst_cf_created, w_inst_cf_time, w_inst_version_time, w_inst_platform_id, w_inst_platform_name, w_inst_rec_incarnation, w_inst_last_incarnation;
               end;

               begin
                  execute immediate 'select value nc from nls_database_parameters@'||r_db_link.instance||'_sarbox where parameter = '||chr(39)||'NLS_LENGTH_SEMANTICS'||chr(39)     into w_inst_nls_length_semantic;
               exception
                  when others then
                  w_inst_nls_length_semantic := 'NA';
               end;

               w_sql := 'select name, free_mb, total_mb from v$asm_diskgroup@'||r_db_link.instance||'_sarbox';
               w_commit:= 0;
               begin
                  open c_asm for w_sql;
                  loop
                     fetch c_asm into w_inst_asm_name, w_inst_asm_free_mb, w_inst_asm_total_mb;
                     exit when c_asm%notfound;
                     if w_commit = 500 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;
                     begin
                        insert into sarbox_instance_storage
                           (instance, filesystem, dtcollect, mountpoint, alocation_type, storage_mode, bytes_aloc, bytes_used, bytes_instance_used, dtdisable, disable)
                        values
                           (upper(r_db_link.instance), w_inst_asm_name, trunc(sysdate), 'ASM', 'INSTANCE ALLOCATION - DATA', 'ASM', (w_inst_asm_total_mb*1024*1024),((w_inst_asm_total_mb-w_inst_asm_free_mb)*1024*1024), (w_inst_size*1024), null, 'NO');
                     exception
                        when dup_val_on_index then
                           update sarbox_instance_storage
                           set    dtdisable  = null
                           ,      disable    = 'NO'
                           where  instance   = upper(r_db_link.instance)
                           and    filesystem = w_inst_asm_name
                           and    dtcollect  = (select max(dtcollect) from sarbox_instance_tablespace where instance = upper(r_db_link.instance) and filesystem = w_inst_asm_name);
                        when others then null;
                     end;
                  end loop;
                  commit;
                  close c_asm;
               exception
                  when others then null;
               end;

               update  sarbox_instance
               set     version                        = w_inst_version
               ,       startup_time                   = w_inst_startup
               ,       instance_number                = w_inst_instnum
               ,       hostname                       = w_inst_host
               ,       cs                             = w_inst_lang||'_'||w_inst_terr||'.'||w_inst_cs
               ,       nls_nchar_cs                   = w_inst_nls_nchar_cs
               ,       nls_length_semantics           = w_inst_nls_length_semantic
               ,       status                         = 'NA'
               ,       message                        = 'Processo iniciado em '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
               ,       errorm                         = null
               ,       statement                      = null
               ,       ksize                          = w_inst_size
               ,       sessions_current               = w_inst_sessions_current
               ,       sessions_highwater             = w_inst_sessions_highwater
               ,       cpu_count_current              = w_inst_cpu_count_current
               ,       cpu_count_highwater            = w_inst_cpu_count_highwater
               ,       fixed_size                     = w_inst_fixed_size
               ,       variable_size                  = w_inst_variable_size
               ,       database_buffers               = w_inst_database_buffers
               ,       redo_buffers                   = w_inst_redo_buffers
               ,       created                        = w_inst_created
               ,       resetlogs_time                 = w_inst_resetlogs_time
               ,       controlfile_created            = w_inst_cf_created
               ,       controlfile_time               = w_inst_cf_time
               ,       version_time                   = w_inst_version_time
               ,       platform_id                    = w_inst_platform_id
               ,       platform_name                  = w_inst_platform_name
               ,       recovery_target_incarnation#   = w_inst_rec_incarnation
               ,       last_open_incarnation#         = w_inst_last_incarnation
               ,       server_instances               = w_inst_serverinst
               ,       server_instances_active        = w_inst_serverinst_act
               ,       file_autoextensible            = w_inst_fileauto
               ,       log_mode                       = w_inst_logmode
               where   instance = r_db_link.instance;
               commit;

               /*
               ** carregar dados de export
               */
               -- faz a carga
               begin
                  w_sql := 'select d4nidprc, d4nstart, d4nendpc, d4nstats, d4nfsize, d4nmerro, d4nmerre, d4nfname from d4nlexpt@'||r_db_link.instance||'_sarbox where d4nstart >= trunc(sysdate)-3';
                  w_commit:= 0;
                  open c_export for w_sql;
                  loop
                     fetch c_export into w_exp_idprc, w_exp_start, w_exp_end, w_exp_status, w_filesize, w_message_ora, w_message_exp, w_filename;
                     exit when c_export%notfound;
                     w_pos1   := 0;
                     w_len1   := 0;
                     w_pos1   := instr(w_exp_idprc, '_') + 1;
                     w_len1   := instr(w_exp_idprc, '_', -1) - w_pos1;
                     w_instnm := upper(substr(w_exp_idprc, w_pos1, w_len1));
                     --dbms_output.put_line(r_db_link.instance||' - '||w_instnm);
                     if instr(upper(r_db_link.instance), w_instnm) <> 0 then
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;
                        update sarbox_instance_export
                        set started          = w_exp_start
                        ,   ended            = w_exp_end
                        ,   status           = w_exp_status
                        ,   filesize         = w_filesize
                        ,   message_ora      = w_message_ora
                        ,   message_exp      = w_message_exp
                        ,   filename         = w_filename
                        where instance       = upper(r_db_link.instance)
                        and   id_process     = w_exp_idprc;
                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_export
                                 (instance, id_process, started, ended, status, exptype, filesize, message_ora, message_exp, filename)
                              values
                                 (upper(r_db_link.instance), w_exp_idprc, w_exp_start, w_exp_end, w_exp_status, substr(w_exp_status, 1 , instr(w_exp_status, ':')-1), w_filesize, w_message_ora, w_message_exp, w_filename);
                        end if;
                     end if;
                  end loop;
                  commit;
                  close c_export;
               exception
                  when others then
                     if sqlcode = -942 then
                        null;
                     end if;
               end;

               
               /*
               ** carregar dados de startup
               */
               -- faz a carga
               begin
                  w_sql := 'select d4odalog, d4oinstd, d4odbnam, d4ousora, d4oususo, d4omaqui, d4oopera, d4ohostn, d4oversn, d4ostatu, d4oarchv, d4ologin, d4odbsts, d4oarchm, d4osttdt, d4oshtdt from d4ostart@'||r_db_link.instance||'_sarbox where d4oshtdt >= trunc(sysdate)-3';
                  w_commit:= 0;
                  open c_start for w_sql;
                  loop
                     fetch c_start into w_start_startup_time, w_start_instance_id, w_start_instance_name, w_start_user_oracle, w_start_user_so, w_start_terminal, w_start_operation, w_start_host_name, w_start_version, w_start_status, w_start_archiver, w_start_logins, w_start_database_status, w_start_archive_mode, w_start_dtstartup, w_start_dtshutdown;
                     exit when c_start%notfound;
                     if instr(upper(w_start_instance_name), upper(replace(r_db_link.instance, 'ORA', ''))) <> 0 then
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_startup
                        set    dtshutdown    = w_start_dtshutdown
                        where  instance      = upper(r_db_link.instance)
                        and    startup_time  = w_start_startup_time;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_startup
                                 ( instance,                   startup_time,              instance_id
                                 , instance_name,              user_oracle,               user_so
                                 , terminal,                   operation,                 host_name
                                 , version,                    status,                    archiver
                                 , logins,                     database_status,           archive_mode
                                 , dtstartup,                  dtshutdown
                                 )
                              values
                                 ( upper(r_db_link.instance),  w_start_startup_time,      w_start_instance_id
                                 , w_start_instance_name,      w_start_user_oracle,       w_start_user_so
                                 , w_start_terminal,           w_start_operation,         w_start_host_name
                                 , w_start_version,            w_start_status,            w_start_archiver
                                 , w_start_logins,             w_start_database_status,   w_start_archive_mode
                                 , w_start_dtstartup,          w_start_dtshutdown
                                 );
                        end if;
                     end if;
                  end loop;
                  commit;
                  close c_start;
               exception
                  when dup_val_on_index then null;
                  when others then
                     if sqlcode = -942 then
                        null;
                     end if;
               end;

               if p_full = 'S' then
                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'010 - Informações da instância');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** coleta as piores queries de cada instância
                  */ 
                  stp_sarbox_inst_top_qry_tun(r_db_link.instance);

                  /*
                  ** Coleta informações de partição para cada instância
                  */
                  carrega_partic_tab(r_db_link.instance);
                  
                  /*
                  ** copia dba objects para local
                  */
                  w_sql := '';
                  w_sql := 'truncate table sarbox_temp_instance_object drop storage';
                  execute immediate w_sql;
                  w_sql := '';
                  w_sql := 'insert into sarbox_temp_instance_object select '||chr(39)||upper(r_db_link.instance)||chr(39)||' instance,owner,object_name,subobject_name,nvl(object_id, -1) object_id,data_object_id,object_type,created,last_ddl_time,timestamp,status,temporary,generated,secondary from dba_objects@'||r_db_link.instance||'_sarbox where owner <> '||chr(39)||'SYS'||chr(39);
                  execute immediate w_sql;

                  /*
                  ** carregar usuarios da dba_users
                  */
                  -- marca todos os usuarios como excluidos (os que não estão como excluidos)
                  w_datetimeproc := sysdate;
                  for r_user_ex in (select rowid from sarbox_instance_user where instance = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_user
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_user_ex.rowid;
                  end loop;
                  commit;
                  -- faz a carga
                  if nvl(upper(r_db_link.search_trace), 'Y') = 'Y' then
                     w_sql := 'select du.username, du.account_status, du.profile, su.password, du.lock_date, du.expiry_date, du.default_tablespace, du.temporary_tablespace, nvl(d4idalog, nvl(lock_date, created)) last_logon, created from dba_users@'||r_db_link.instance||'_sarbox du, sys.user$@'||r_db_link.instance||'_sarbox su, (select d4iusora, max(d4idalog) d4idalog from bdtrace.d4illogt@'||r_db_link.instance||'_sarbox group by d4iusora) di where du.username = di.d4iusora(+) and su.name = du.username';
                  else
                     w_sql := 'select du.username, du.account_status, du.profile, su.password, du.lock_date, du.expiry_date, du.default_tablespace, du.temporary_tablespace, null last_logon, created from dba_users@'||r_db_link.instance||'_sarbox du, sys.user$@'||r_db_link.instance||'_sarbox su where su.name = du.username';
                  end if;
                  --dbms_output.put_line(w_sql);
                  w_commit:= 0;
                  open c_users for w_sql;
                  loop
                     fetch c_users into w_user_username, w_user_status, w_user_profile, w_user_password, w_user_ldate, w_expiry_date, w_tbs_default, w_tbs_temporary, w_last_logon, w_user_created;
                     exit when c_users%notfound;
                     if w_commit = 500 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;
                     /*
                     ** se é owner de objetos que não db_link
                     */
                     w_rows      := 0;
                     w_sql_owner := '';
                     --w_sql_owner := 'select count(1) from dba_objects@'||r_db_link.instance||'_sarbox where owner = '||chr(39)||w_user_username||chr(39)||' and rownum = 1 and object_type not in ('||chr(39)||'SYNONYM'||chr(39)||','||chr(39)||'DATABASE LINK'||chr(39)||') and object_name <> '||chr(39)||'PLAN_TABLE'||chr(39);

                     --w_sql_owner := 'select count(1) from sarbox_temp_instance_object where instance = '||chr(39)||r_db_link.instance||chr(39)||' and owner = '||chr(39)||w_user_username||chr(39)||' and object_type not in ('||chr(39)||'SYNONYM'||chr(39)||','||chr(39)||'DATABASE LINK'||chr(39)||') and object_name <> '||chr(39)||'PLAN_TABLE'||chr(39)||' and rownum = 1';
                     w_rows := 0;
                     select count(1)
                     into   w_rows
                     from   sarbox_temp_instance_object
                     where  instance    = r_db_link.instance
                     and    owner       = w_user_username
                     and    object_type not in ('SYNONYM','DATABASE LINK')
                     and    object_name <> 'PLAN_TABLE'
                     and    rownum      = 1;

                     --dbms_output.put_line(w_sql_owner );
                     --execute immediate w_sql_owner into w_rows;
                     if w_rows = 0 then
                        w_user_owner := 'NO';
                     else
                        w_user_owner := 'YES';
                     end if;
                     /*
                     ** se é owner de objetos que sejam db_link
                     */
                     w_rows            := 0;
                     w_user_owner_link := '';
                     --w_sql_owner := 'select count(1) from dba_objects@'||r_db_link.instance||'_sarbox where owner = '||chr(39)||w_user_username||chr(39)||' and rownum = 1 and object_type = '||chr(39)||'DATABASE LINK'||chr(39)||' and object_name <> '||chr(39)||'PLAN_TABLE'||chr(39);

                     --w_sql_owner := 'select count(1) from sarbox_temp_instance_object where instance = '||chr(39)||r_db_link.instance||chr(39)||' and owner = '||chr(39)||w_user_username||chr(39)||' and object_type = '||chr(39)||'DATABASE LINK'||chr(39)||' and object_name <> '||chr(39)||'PLAN_TABLE'||chr(39)||' and rownum = 1';
                     w_rows := 0;
                     select count(1)
                     into   w_rows
                     from   sarbox_temp_instance_object
                     where  instance    = r_db_link.instance
                     and    owner       = w_user_username
                     and    object_type = 'DATABASE LINK'
                     and    object_name <> 'PLAN_TABLE'
                     and    rownum = 1;

                     --dbms_output.put_line(w_sql_owner );
                     --execute immediate w_sql_owner into w_rows;
                     if w_rows = 0 then
                        w_user_owner_link := 'NO';
                     else
                        w_user_owner_link := 'YES';
                     end if;

                     if w_last_logon is not null then
                        if w_last_logon < w_user_created then
                           w_last_logon := w_user_created;
                        end if;
                     end if;

                     update sarbox_instance_user
                     set   status               = w_user_status
                     ,     owner                = w_user_owner
                     ,     owner_dblink         = w_user_owner_link
                     ,     profile              = w_user_profile
                     ,     dropped              = 'NO'
                     ,     dtdropped            = null
                     ,     lock_date            = w_user_ldate
                     ,     expiry_date          = w_expiry_date
                     ,     default_tablespace   = w_tbs_default
                     ,     temporary_tablespace = w_tbs_temporary
                     ,     last_logon           = w_last_logon
                     ,     created              = w_user_created
                     where instance             = upper(r_db_link.instance)
                     and   username             = w_user_username;

                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_user
                              (instance, username, status, owner, dtinsert, dtupdate, profile, rdbms, tpcarga, dropped, owner_dblink, lock_date, expiry_date, last_logon, default_tablespace, temporary_tablespace, created)
                           values
                              (upper(r_db_link.instance), w_user_username, w_user_status, w_user_owner, sysdate, sysdate, w_user_profile, 'ORACLE', 'A', 'NO', w_user_owner_link, w_user_ldate, w_expiry_date, w_last_logon, w_tbs_default, w_tbs_temporary, w_user_created);
                     end if;

                     /*
                     ** histórico simples de senha de 1 mês
                     */
                     insert into sarbox_instance_user_history
                        (instance, username, dtcoleta, password, status, profile, lock_date, expiry_date)
                     values
                        (upper(r_db_link.instance), w_user_username, sysdate, w_user_password, w_user_status, w_user_profile, w_user_ldate, w_expiry_date);
                  end loop;
                  commit;
                  close c_users;
                  -- grava na tabela de histórico a informação da exclusão do usuário
                  for r_user_ex in (select username, dtdropped from sarbox_instance_user where instance = upper(r_db_link.instance) and dropped <> 'YES' and dtdropped = w_datetimeproc)
                  loop
                     grava_log(upper(r_db_link.instance), 'SARBOX_INSTANCE_USER', 'DROPPED', r_user_ex.username, w_datetimeproc, 'Usuário excluído');
                  end loop;
                  commit;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'020 - Carga de usuários');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** carregar os usuários da user$ - reservado
                  */
                  -- marca como excluido
                  for r_user$_ex in (select rowid from sarbox_instance_user$ where instance = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_user$
                     set    dropped   = 'YES'
                     ,      dtdropped = SYSDATE
                     where rowid = r_user$_ex.rowid;
                  end loop;
                  commit;
                  -- faz a carga
                  w_sql := 'select user#, name, type#, password, datats#, tempts#, ctime, ptime, exptime, ltime, resource$, audit$, defrole, defgrp#, defgrp_seq#, astatus, lcount, defschclass, ext_username, spare1, spare2, spare3, spare4, spare5, spare6 from sys.user$@'||r_db_link.instance||'_sarbox';
                  w_commit:= 0;
                  open c_user$ for w_sql;
                  loop
                     fetch c_user$ into w_usr$_user#, w_usr$_name, w_usr$_type#, w_usr$_password, w_usr$_datats#, w_usr$_tempts#, w_usr$_ctime, w_usr$_ptime, w_usr$_exptime, w_usr$_ltime, w_usr$_resource$, w_usr$_audit$, w_usr$_defrole, w_usr$_defgrp#, w_usr$_defgrp_seq#, w_usr$_astatus, w_usr$_lcount, w_usr$_defschclass, w_usr$_ext_username, w_usr$_spare1, w_usr$_spare2, w_usr$_spare3, w_usr$_spare4, w_usr$_spare5, w_usr$_spare6;
                     exit when c_user$%notfound;
                     if w_commit = 500 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;

                     update sarbox_instance_user$
                     set type#            = w_usr$_type#
                     ,   password         = w_usr$_password
                     ,   datats#          = w_usr$_datats#
                     ,   tempts#          = w_usr$_tempts#
                     ,   ctime            = w_usr$_ctime
                     ,   ptime            = w_usr$_ptime
                     ,   exptime          = w_usr$_exptime
                     ,   ltime            = w_usr$_ltime
                     ,   resource$        = w_usr$_resource$
                     ,   audit$           = w_usr$_audit$
                     ,   defrole          = w_usr$_defrole
                     ,   defgrp#          = w_usr$_defgrp#
                     ,   defgrp_seq#      = w_usr$_defgrp_seq#
                     ,   astatus          = w_usr$_astatus
                     ,   lcount           = w_usr$_lcount
                     ,   defschclass      = w_usr$_defschclass
                     ,   ext_username     = w_usr$_ext_username
                     ,   spare1           = w_usr$_spare1
                     ,   spare2           = w_usr$_spare2
                     ,   spare3           = w_usr$_spare3
                     ,   spare4           = w_usr$_spare4
                     ,   spare5           = w_usr$_spare5
                     ,   spare6           = w_usr$_spare6
                     ,   dropped    = 'NO'
                     ,   dtdropped  = null
                     where instance = upper(r_db_link.instance)
                     and   user#    = w_usr$_user#
                     and   name     = w_usr$_name;

                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_user$
                              (instance, user#, name, type#, password, datats#, tempts#, ctime, ptime, exptime, ltime, resource$, audit$, defrole, defgrp#, defgrp_seq#, astatus, lcount, defschclass, ext_username, spare1, spare2, spare3, spare4, spare5, spare6, dtinsert, dropped)
                           values
                              (upper(r_db_link.instance), w_usr$_user#, w_usr$_name, w_usr$_type#, w_usr$_password, w_usr$_datats#, w_usr$_tempts#, w_usr$_ctime, w_usr$_ptime, w_usr$_exptime, w_usr$_ltime, w_usr$_resource$, w_usr$_audit$, w_usr$_defrole, w_usr$_defgrp#, w_usr$_defgrp_seq#, w_usr$_astatus, w_usr$_lcount, w_usr$_defschclass, w_usr$_ext_username, w_usr$_spare1, w_usr$_spare2, w_usr$_spare3, w_usr$_spare4, w_usr$_spare5, w_usr$_spare6, sysdate, 'NO');
                     end if;

                  end loop;
                  commit;
                  close c_user$;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'030 - Carga de usuários - resevado');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** carregar parametros para a instance
                  */
                  -- marca como excluido
                  w_datetimeproc := sysdate;
                  for r_parameter_ex in (select rowid from sarbox_instance_parameter where instance = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_parameter
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_parameter_ex.rowid;
                  end loop;
                  commit;
                  -- faz a carga
                  w_sql := 'select inst_id, name, num, type, value, isdefault, ismodified, isadjusted from gv$parameter@'||r_db_link.instance||'_sarbox';
                  w_commit:= 0;
                  open c_parameter for w_sql;
                  loop
                     fetch c_parameter into w_parameter_instid, w_parameter_name, w_parameter_num, w_parameter_type, w_parameter_value, w_parameter_isdefault, w_parameter_ismodified, w_parameter_isadjusted;
                     exit when c_parameter%notfound;
                     if w_commit = 500 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;

                     update sarbox_instance_parameter
                     set name       =    w_parameter_name
                     ,   num        =    w_parameter_num
                     ,   type       =    w_parameter_type
                     ,   value      =    w_parameter_value
                     ,   isdefault  =    w_parameter_isdefault
                     ,   ismodified =    w_parameter_ismodified
                     ,   isadjusted =    w_parameter_isadjusted
                     ,   dropped    = 'NO'
                     ,   dtdropped  = null
                     where instance = upper(r_db_link.instance)
                     and   inst_id  = w_parameter_instid
                     and   name     = w_parameter_name;

                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_parameter
                              (instance, inst_id, name, num, type, value, isdefault, ismodified, isadjusted, dtinsert, dtdropped, dropped)
                           values
                              (upper(r_db_link.instance), w_parameter_instid, w_parameter_name, w_parameter_num, w_parameter_type, w_parameter_value, w_parameter_isdefault, w_parameter_ismodified, w_parameter_isadjusted, sysdate, sysdate, 'NO');
                     end if;
                  end loop;
                  commit;
                  close c_parameter;
                  -- grava na tabela de histórico a informação da exclusão do parametro
                  for r_parameter_ex in (select name, inst_id from sarbox_instance_parameter where instance = upper(r_db_link.instance) and dropped <> 'YES' and dtdropped = w_datetimeproc)
                  loop
                     grava_log(upper(r_db_link.instance), 'SARBOX_INSTANCE_PARAMETER', 'DROPPED', r_parameter_ex.name, w_datetimeproc, 'Parâmetro excluído', r_parameter_ex.inst_id);
                  end loop;
                  commit;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'040 - Carga de parâmetros');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;


                  if nvl(upper(r_db_link.search_links), 'Y') = 'Y' then
                     /*
                     ** carregar db_links da instance
                     */
                     -- marca como excluido
                     w_datetimeproc := sysdate;
                     for r_link_ex in (select rowid from sarbox_instance_link where instance = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_link
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_link_ex.rowid;
                     end loop;
                     commit;
                     -- faz a carga

                     --if to_number(replace(nvl(substr(w_inst_version, 1, instr(w_inst_version, '.')), '8'), '.', '')) >= 10  then
                     if to_number(replace(nvl(substr(w_inst_version, 1, instr(w_inst_version, '.')), '8'), '.', '')||replace(nvl(substr(w_inst_version, instr(w_inst_version, '.')+1, 1), '0'), '.', '')) >= 102 then
                        w_sql := 'select u.name owner,l.name dblink,l.ctime,l.host,l.userid,l.password,l.flag,l.authusr,l.authpwd, l.passwordx passwordx from sys.link$@'||r_db_link.instance||'_sarbox l, sys.user$@'||r_db_link.instance||'_sarbox u where l.owner# = u.user#';
                     else
                        w_sql := 'select u.name owner,l.name dblink,l.ctime,l.host,l.userid,l.password,l.flag,l.authusr,l.authpwd, null passwordx from sys.link$@'||r_db_link.instance||'_sarbox l, sys.user$@'||r_db_link.instance||'_sarbox u where l.owner# = u.user#';
                     end if;
                     w_commit:= 0;
                     open c_links for w_sql;
                     loop
                        fetch c_links into w_link_owner, w_link_dblink, w_link_ctime, w_link_host, w_link_username, w_link_password, w_link_flag, w_link_authusr, w_link_autphwd, w_link_passwordx;
                        exit when c_links%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_link
                        set ctime      = w_link_ctime
                        ,   host       = w_link_host
                        ,   username   = w_link_username
                        ,   password   = w_link_password
                        ,   flag       = w_link_flag
                        ,   authusr    = w_link_authusr
                        ,   autphpwd   = w_link_autphwd
                        ,   passwordx  = w_link_passwordx
                        ,   dropped    = 'NO'
                        ,   dtdropped  = null
                        where instance = upper(r_db_link.instance)
                        and   owner    = w_link_owner
                        and   dblink   = w_link_dblink;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_link
                                 (instance, owner, dblink, ctime, host, username, password, flag, authusr, autphpwd, dtupdate, dtinsert, dropped, passwordx)
                              values
                                 (upper(r_db_link.instance), w_link_owner, w_link_dblink, w_link_ctime, w_link_host, w_link_username, w_link_password, w_link_flag, w_link_authusr, w_link_autphwd, sysdate, sysdate, 'NO', w_link_passwordx);
                        end if;

                     end loop;
                     commit;
                     close c_links;
                     -- grava na tabela de histórico a informação da exclusão do parametro
                     for r_link_ex in (select w_link_owner, dblink from sarbox_instance_link where instance = upper(r_db_link.instance) and dropped <> 'YES' and dtdropped = w_datetimeproc)
                     loop
                        grava_log(upper(r_db_link.instance), 'SARBOX_INSTANCE_LINK', 'DROPPED', r_link_ex.w_link_owner||' - '||r_link_ex.dblink, w_datetimeproc, 'DB_LINK excluído');
                     end loop;
                     commit;
                  end if;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'050 - Carga de db_links');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  if nvl(upper(r_db_link.search_profile), 'Y') = 'Y' then
                     /*
                     ** carregar profiles da instance
                     */
                     -- marca todos os profiles como excluídos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     for r_profile_ex in (select rowid from sarbox_instance_profile where instance = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_profile
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_profile_ex.rowid;
                     end loop;
                     commit;
                     -- faz a carga
                     w_sql := 'select profile,resource_name,resource_type,limit from dba_profiles@'||r_db_link.instance||'_sarbox';
                     w_commit:= 0;
                     open c_profiles for w_sql;
                     loop
                        fetch c_profiles into w_profile_name, w_profile_rname, w_profile_rtype, w_profile_limit;
                        exit when c_profiles%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_profile
                        set   limit           = w_profile_limit
                        ,     dropped         = 'NO'
                        ,     dtdropped       = null
                        where instance        = upper(r_db_link.instance)
                        and   profile         = w_profile_name
                        and   resource_name   = w_profile_rname;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_profile
                                 (instance, profile, resource_name, resource_type, limit, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_profile_name, w_profile_rname, w_profile_rtype, w_profile_limit, 'NO', null);
                        end if;

                     end loop;
                     commit;
                     close c_profiles;
                  end if;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'060 - Carga de profiles');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  **  carregar registry
                  */
                  if to_number(replace(nvl(substr(w_inst_version, 1, instr(w_inst_version, '.')), '8'), '.', '')) >= 10  then
                     w_sql := 'select comp_id,comp_name,version,status,modified,namespace,control,schema,procedure,startup,parent_id,other_schemas from dba_registry@'||r_db_link.instance||'_sarbox';
                  else
                     w_sql := 'select comp_id,comp_name,version,status,modified,null namespace,control,schema,procedure,startup,parent_id,null other_schemas from dba_registry@'||r_db_link.instance||'_sarbox';
                  end if;
                  w_commit:= 0;
                  begin
                     open c_registry for w_sql;
                     loop
                        fetch c_registry into w_reg_comp_id, w_reg_comp_name, w_reg_version, w_reg_status, w_reg_modified, w_reg_namespace, w_reg_control, w_reg_schema, w_reg_procedure, w_reg_startup, w_reg_parent_id, w_reg_other_schemas;
                        exit when c_registry%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;
                        update sarbox_instance_registry
                        set   comp_name       = w_reg_comp_name
                        ,     version         = w_reg_version
                        ,     status          = w_reg_status
                        ,     modified        = w_reg_modified
                        ,     namespace       = w_reg_namespace
                        ,     control         = w_reg_control
                        ,     schema          = w_reg_schema
                        ,     proc            = w_reg_procedure
                        ,     startup         = w_reg_startup
                        ,     parent_id       = w_reg_parent_id
                        ,     other_schemas   = w_reg_other_schemas
                        where instance        = upper(r_db_link.instance)
                        and   comp_id         = w_reg_comp_id;
                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_registry
                                 (instance, comp_id,comp_name,version,status,modified,namespace,control,schema,proc,startup,parent_id,other_schemas)
                              values
                                 (upper(r_db_link.instance), w_reg_comp_id, w_reg_comp_name, w_reg_version, w_reg_status, w_reg_modified, w_reg_namespace, w_reg_control, w_reg_schema, w_reg_procedure, w_reg_startup, w_reg_parent_id, w_reg_other_schemas);
                        end if;
                     end loop;
                     commit;
                     close c_registry;
                  exception
                     when others then null;
                  end;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'070 - Carga de registry');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  **  carregar rac
                  */
                  if r_db_link.server_instances > 1 then
                     for r_rac_ex in (select rowid from sarbox_instance_rac where instance = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_rac
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_rac_ex.rowid;
                     end loop;
                     commit;

                     w_sql := 'select instance_name,inst_id,host_name,startup_time,shutdown_pending from gv$instance@'||r_db_link.instance||'_sarbox';
                     w_commit:= 0;
                   
                     begin
                        open c_rac for w_sql;
                        loop
                           fetch c_rac into w_rac_instance_name, w_rac_inst_id, w_rac_host_name, w_rac_startup_time, w_rac_shutdown_pending;
                           exit when c_rac%notfound;
                           if w_commit = 500 then
                              commit;
                              w_commit := 0;
                           end if;
                           w_commit := w_commit + 1;
                           update sarbox_instance_rac
                           set   inst_id           = w_rac_inst_id
                           ,     host_name         = w_rac_host_name
                           ,     startup_time      = w_rac_startup_time
                           ,     shutdown_pending  = w_rac_shutdown_pending
                           ,     dropped           = 'NO'
                           ,     dtdropped         = null
                           where instance          = upper(r_db_link.instance)
                           and   instance_name     = w_rac_instance_name;
                           if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                              insert
                              into sarbox_instance_rac
                                 (instance, instance_name, inst_id, host_name, startup_time, shutdown_pending, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_rac_instance_name, w_rac_inst_id, w_rac_host_name, w_rac_startup_time, w_rac_shutdown_pending, 'NO', null);
                           end if;
                        end loop;
                        commit;
                        close c_rac;
                     exception
                        when others then null;
                     end;
               end if;


                  /*
                  **  carregar tablespaces
                  */
                  if upper(r_db_link.check_pcs) = 'Y' then
                     -- marca todos os objects como excluidos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     for r_tablespace_ex in (select rowid from sarbox_instance_tablespace where disable <> 'YES' and instance = upper(r_db_link.instance))
                     loop
                        update sarbox_instance_tablespace
                        set    disable   = 'YES'
                        ,      dtdisable = w_datetimeproc
                        where rowid = r_tablespace_ex.rowid;
                     end loop;
                     commit;

                     --w_sql := 'select d4ltbsnm, d4ldtupd, d4lsegtp, d4ltbstp, d4ltbsmn, d4lalocb ,d4lusedb from d4lsegst@'||r_db_link.instance||'_sarbox where d4ldtupd >= trunc(sysdate-3) and d4lusora  = '||chr(39)||'N/A SYSTEM'||chr(39);
                     -- 20100607 - w_sql := 'select d4ltbsnm, d4ldtupd, d4lsegtp, decode(d4ltbsnm, '||chr(39)||'FS INSTANCE ALLOCATION'||chr(39)||', d4lsegnm, d4ltbstp) d4ltbsnm, decode(d4ltbsnm, '||chr(39)||'FS INSTANCE ALLOCATION'||chr(39)||', d4lprtnm, d4ltbsmn) d4ltbsmn, d4lalocb ,d4lusedb from d4lsegst@'||r_db_link.instance||'_sarbox where d4ldtupd >= trunc(sysdate-3) and d4lusora  = '||chr(39)||'N/A SYSTEM'||chr(39);
                     w_sql := 'select d4ltbsnm, d4ldtupd, d4lsegtp, decode(d4lsegtp, '||chr(39)||'N/A'||chr(39)||', d4lsegnm, d4ltbstp) d4lsegnm, decode(d4lsegtp,'||chr(39)||'N/A'||chr(39)||', d4lprtnm, d4ltbsmn) d4ltbsmn, d4lalocb ,d4lusedb from d4lsegst@'||r_db_link.instance||'_sarbox where  d4ldtupd >= trunc(sysdate-3) and d4lusora  = '||chr(39)||'N/A SYSTEM'||chr(39);

                     w_commit:= 0;
                     begin
                        open c_tablespace for w_sql;
                        loop
                           fetch c_tablespace into w_tbs_name, w_tbs_dtcollect, w_tbs_contents, w_tbs_allocation, w_tbs_management, w_tbs_baloc, w_tbs_bused;
                           exit when c_tablespace%notfound;
                           if w_commit = 500 then
                              commit;
                              w_commit := 0;
                           end if;
                           w_commit := w_commit + 1;
                           begin
                              insert
                                 into sarbox_instance_tablespace
                                    (instance, tablespace_name, dtcollect, contents, allocation_type, extent_management, bytes_aloc, bytes_used, dtdisable, disable)
                                 values
                                    (upper(r_db_link.instance), w_tbs_name, w_tbs_dtcollect, w_tbs_contents, w_tbs_allocation, w_tbs_management, w_tbs_baloc, w_tbs_bused, null, 'NO');
                           exception
                              when dup_val_on_index then
                                 update sarbox_instance_tablespace
                                 set    dtdisable = null
                                 ,      disable   = 'NO'
                                 where  instance        = upper(r_db_link.instance)
                                 and    tablespace_name = w_tbs_name
                                 and    dtcollect = (select max(dtcollect) from sarbox_instance_tablespace where instance = upper(r_db_link.instance) and tablespace_name = w_tbs_name);
                              when others then null;
                           end;
                        end loop;
                        commit;
                        close c_tablespace;
                     exception
                        when others then null;
                     end;

                     -- verifica quais os tablespaces que foram excluídos
                     w_datetimeproc := sysdate;
                     for r_tablespace_ex in (select rowid from sarbox_instance_tablespace where disable <> 'YES' and instance = upper(r_db_link.instance))
                     loop
                        update sarbox_instance_tablespace
                        set    disable   = 'YES'
                        ,      dtdisable = w_datetimeproc
                        where rowid = r_tablespace_ex.rowid;
                     end loop;
                     commit;
                     w_sql := 'select tablespace_name from dba_tablespaces@'||r_db_link.instance||'_sarbox';
                     w_commit:= 0;
                     begin
                        open c_tablespace for w_sql;
                        loop
                           fetch c_tablespace into w_tbs_name;
                           exit when c_tablespace%notfound;
                           if w_commit = 500 then
                              commit;
                              w_commit := 0;
                           end if;
                           w_commit := w_commit + 1;
                           update sarbox_instance_tablespace
                           set    dtdisable = null
                           ,      disable   = 'NO'
                           where  instance        = upper(r_db_link.instance)
                           and    tablespace_name = w_tbs_name
                           and    dtcollect = (select max(dtcollect) from sarbox_instance_tablespace where instance = upper(r_db_link.instance) and tablespace_name = w_tbs_name);
                        end loop;
                        commit;
                        close c_tablespace;
                     exception
                        when others then null;
                     end;
                  end if;
                  commit;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'080 - Carga de tablespaces');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** carregar informacao de fs + ASM
                  */
                  for r_fs_ex in (select rowid from sarbox_instance_storage where disable <> 'YES' and instance = upper(r_db_link.instance))
                  loop
                     update sarbox_instance_storage
                     set    disable   = 'YES'
                     ,      dtdisable = w_datetimeproc
                     where  rowid     = r_fs_ex.rowid;
                  end loop;
                  commit;
                  w_sql := 'select d4ltbsnm, d4ldtupd, d4lsegnm, d4lprtnm, d4lalocb ,d4lusedb from d4lsegst@'||r_db_link.instance||'_sarbox where  d4ldtupd >= trunc(sysdate-3) and d4lusora  = '||chr(39)||'N/A SYSTEM'||chr(39)||' and d4lprtnm <> '||chr(39)||'N/A'||chr(39);
                  w_commit:= 0;
                  begin
                     open c_storage for w_sql;
                     loop
                        fetch c_storage into w_stg_alocation_type, w_stg_dtcollect, w_stg_mountpoint, w_stg_filesystem, w_stg_baloc, w_stg_bused;
                        exit when c_storage%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;
                        begin
                           insert
                              into sarbox_instance_storage
                                 (instance, filesystem, dtcollect, mountpoint, alocation_type, storage_mode, bytes_aloc, bytes_used, bytes_instance_used, dtdisable, disable)
                              values
                                 (upper(r_db_link.instance), w_stg_filesystem, w_stg_dtcollect, w_stg_mountpoint, w_stg_alocation_type, 'FS', w_stg_baloc, w_stg_bused, 0, null, 'NO');
                        exception
                           when dup_val_on_index then
                              update sarbox_instance_storage
                              set    dtdisable = null
                              ,      disable   = 'NO'
                              where  instance        = upper(r_db_link.instance)
                              and    filesystem = w_stg_filesystem
                              and    dtcollect = (select max(dtcollect) from sarbox_instance_tablespace where instance = upper(r_db_link.instance) and filesystem = w_stg_filesystem);
                           when others then null;
                        end;
                     end loop;
                     commit;
                     close c_storage;
                  exception
                     when others then null;
                  end;

                  /*
                  ** carregar objects da instance
                  */
                  -- marca todos os objects como excluidos (os que não estão como excluidos)
                  w_datetimeproc := sysdate;
                  for r_object_ex in (select rowid from sarbox_instance_object where instance = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_object
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_object_ex.rowid;
                  end loop;
                  commit;
                  -- faz a carga
                  w_sql := '';
                  w_sql := 'select owner,object_name,subobject_name,object_id,data_object_id,object_type,created,last_ddl_time,timestamp,status,temporary,generated,secondary from sarbox_temp_instance_object where instance = '||chr(39)||upper(r_db_link.instance)||chr(39);
                  w_commit:= 0;
                  open c_objects for w_sql;
                  loop
                     fetch c_objects into w_object_owner, w_object_object_name, w_object_subobject_name, w_object_object_id, w_object_data_object_id, w_object_object_type, w_object_created, w_object_last_ddl_time, w_object_timestamp, w_object_status, w_object_temporary, w_object_generated, w_object_secondary;
                     exit when c_objects%notfound;
                     if w_commit = 10000 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;

                     update sarbox_instance_object
                     set   dropped         = 'NO'
                     ,     dtdropped       = null
                     ,     last_ddl_time   = w_object_last_ddl_time
                     ,     status          = w_object_status
                     ,     timestamp       = w_object_timestamp
                     where instance        = upper(r_db_link.instance)
                     and   owner           = w_object_owner
                     and   object_id       = w_object_object_id
                     and   object_name     = w_object_object_name;
                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_object
                              (instance, owner, object_name, subobject_name, object_id, data_object_id, object_type, created, last_ddl_time, timestamp, status, temporary, generated, secondary, dropped, dtdropped)
                           values
                              (upper(r_db_link.instance), w_object_owner, w_object_object_name, w_object_subobject_name, w_object_object_id, w_object_data_object_id, w_object_object_type, w_object_created, w_object_last_ddl_time, w_object_timestamp, w_object_status, w_object_temporary, w_object_generated, w_object_secondary, 'NO', null);
                     end if;

                  end loop;
                  commit;
                  close c_objects;

                  -- grava na tabela de histórico a informação da exclusão de objeto
                  for r_object_ex in (select owner, object_name, object_type from sarbox_instance_object where instance = upper(r_db_link.instance) and dropped <> 'YES' and dtdropped = w_datetimeproc)
                  loop
                     grava_log(upper(r_db_link.instance), 'SARBOX_INSTANCE_OBJECT', 'DROPPED', r_object_ex.owner||' - '||r_object_ex.object_type||' - '||r_object_ex.object_type, w_datetimeproc, 'Objeto excluído');
                  end loop;
                  commit;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'090 - Carga de objetos');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  w_sql := '';
                  w_sql := 'truncate table sarbox_temp_instance_object drop storage';
                  execute immediate w_sql;

                  if nvl(upper(r_db_link.search_privs), 'Y') = 'Y' then
                     /*
                     ** carregar role da instance
                     */
                     -- marca todos as role como excluidos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     for r_role_ex in (select rowid from sarbox_instance_role where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_role
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_role_ex.rowid;
                     end loop;
                     commit;
                     -- faz a carga
                     w_sql := 'select role,password_required from dba_roles@'||r_db_link.instance||'_sarbox';
                     w_commit:= 0;
                     open c_roles for w_sql;
                     loop
                        fetch c_roles into w_role_role, w_role_password_required;
                        exit when c_roles%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_role
                        set   dropped         = 'NO'
                        ,     dtdropped       = null
                        where instance        = upper(r_db_link.instance)
                        and   role            = w_role_role;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_role
                                 (instance, role, password_required, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_role_role, w_role_password_required, 'NO', null);
                        end if;

                     end loop;
                     commit;
                     close c_roles;

                     if adddebuginfo = true then
                        /*
                        ** log de execução
                        */
                        w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                        insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'100 - Carga das roles');
                        w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     end if;

                     /*
                     ** carregar role privs da instance
                     */
                     -- marca todos as roleprivs como excluidos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     for r_rolepriv_ex in (select rowid from sarbox_instance_rolepriv where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_rolepriv
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_rolepriv_ex.rowid;
                     end loop;
                     commit;

                     -- faz a carga
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_rolepriv drop storage';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'insert into pcsox.sarbox_temp_instance_rolepriv select distinct '||chr(39)||upper(r_db_link.instance)||chr(39)||' instance, grantee,granted_role,admin_option,default_role from dba_role_privs@'||r_db_link.instance||'_sarbox';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'select grantee,granted_role,admin_option,default_role from pcsox.sarbox_temp_instance_rolepriv where instance = '||chr(39)||upper(r_db_link.instance)||chr(39);
                     w_commit:= 0;
                     open c_roleprivs for w_sql;
                     loop
                        fetch c_roleprivs into w_rolepriv_grantee, w_rolepriv_granted_role, w_rolepriv_admin_option, w_rolepriv_default_role;
                        exit when c_roleprivs%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_rolepriv
                        set   dropped         = 'NO'
                        ,     dtdropped       = null
                        where instance        = upper(r_db_link.instance)
                        and   grantee         = w_rolepriv_grantee
                        and   granted_role    = w_rolepriv_granted_role;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_rolepriv
                                 (instance, grantee, granted_role, admin_option, default_role, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_rolepriv_grantee, w_rolepriv_granted_role, w_rolepriv_admin_option, w_rolepriv_default_role, 'NO', null);
                        end if;

                     end loop;
                     commit;
                     close c_roleprivs;
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_rolepriv drop storage';
                     execute immediate w_sql;
                     if adddebuginfo = true then
                        /*
                        ** log de execução
                        */
                        w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                        insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'110 - Carga de role privs');
                        w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     end if;

                     /*
                     ** carregar role privs da instance
                     */
                     -- marca todos as tab_privs como excluidos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     w_tab_priv_detail := '';
                     w_tab_priv_detail := 'P1S: '||to_char(sysdate, 'dd/mm hh24:mi:ss');
                     for r_tabpriv_ex in (select rowid from sarbox_instance_tabpriv where instance = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                         update sarbox_instance_tabpriv
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_tabpriv_ex.rowid;
                     end loop;
                     commit;
                     w_tab_priv_detail := w_tab_priv_detail ||' - P2S: '||to_char(sysdate, 'dd/mm hh24:mi:ss');

                     -- faz a carga
                     w_sql := '';
                     w_sql := 'insert into sarbox_temp_instance_tabpriv select '||chr(39)||upper(r_db_link.instance)||chr(39)||' instance,grantee,owner,table_name,grantor,privilege,grantable from dba_tab_privs@'||r_db_link.instance||'_sarbox';
                     execute immediate w_sql;
                     w_tab_priv_detail := w_tab_priv_detail ||' - P3S: '||to_char(sysdate, 'dd/mm hh24:mi:ss');

                     w_sql := '';
                     --w_sql := 'select grantee,owner,table_name,grantor,privilege,grantable from dba_tab_privs@'||r_db_link.instance||'_sarbox where not (owner = '||chr(39)||'SYS'||chr(39)||' and grantee = '||chr(39)||'PUBLIC'||chr(39)||') and grantee not like '||chr(39)||'ACB%'||chr(39);
                     w_sql := 'select grantee,owner,table_name,grantor,privilege,grantable from sarbox_temp_instance_tabpriv where instance = '||chr(39)||upper(r_db_link.instance)||chr(39);
                     w_commit:= 0;
                     open c_tabprivs for w_sql;
                     loop
                        fetch c_tabprivs into w_tabpriv_grantee, w_tabpriv_owner, w_tabpriv_table_name, w_tabpriv_grantor, w_tabpriv_privilege, w_tabpriv_grantable;
                        exit when c_tabprivs%notfound;
                        if w_commit = 10000 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_tabpriv
                        set   dropped         = 'NO'
                        ,     dtdropped       = null
                        where instance        = upper(r_db_link.instance)
                        and   grantee         = w_tabpriv_grantee
                        and   owner           = w_tabpriv_owner
                        and   table_name      = w_tabpriv_table_name
                        and   grantor         = w_tabpriv_grantor
                        and   privilege       = w_tabpriv_privilege;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_tabpriv
                                 (instance, grantee, owner, table_name, grantor, privilege, grantable, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_tabpriv_grantee, w_tabpriv_owner, w_tabpriv_table_name, w_tabpriv_grantor, w_tabpriv_privilege, w_tabpriv_grantable, 'NO', null);
                        end if;

                     end loop;
                     commit;
                     w_tab_priv_detail := w_tab_priv_detail ||' - P4S: '||to_char(sysdate, 'dd/mm hh24:mi:ss');
                     close c_tabprivs;
                     w_sql := '';
                     w_sql := 'truncate table sarbox_temp_instance_tabpriv drop storage';
                     execute immediate w_sql;
                     w_tab_priv_detail := w_tab_priv_detail ||' - P5S: '||to_char(sysdate, 'dd/mm hh24:mi:ss');
                     if adddebuginfo = true then
                        /*
                        ** log de execução
                        */
                        w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                        insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'120 - Carga de tab privs'||' - '||w_tab_priv_detail);
                        w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     end if;

                     /*
                     ** carregar sys privs da instance
                     */
                     -- marca todos as sys_privs como excluidos (os que não estão como excluidos)
                     w_datetimeproc := sysdate;
                     for r_syspriv_ex in (select rowid from sarbox_instance_syspriv where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                     loop
                        update sarbox_instance_syspriv
                        set    dropped   = 'YES'
                        ,      dtdropped = w_datetimeproc
                        where rowid = r_syspriv_ex.rowid;
                     end loop;
                     commit;
                     -- faz a carga
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_syspriv drop storage';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'insert into pcsox.sarbox_temp_instance_syspriv select distinct '||chr(39)||upper(r_db_link.instance)||chr(39)||' instance, grantee, privilege, admin_option from dba_sys_privs@'||r_db_link.instance||'_sarbox';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'select grantee,privilege,admin_option from pcsox.sarbox_temp_instance_syspriv where instance = '||chr(39)||upper(r_db_link.instance)||chr(39);
                     w_commit:= 0;
                     open c_sysprivs for w_sql;
                     loop
                        fetch c_sysprivs into w_syspriv_grantee, w_syspriv_privilege, w_syspriv_admin_option;
                        exit when c_sysprivs%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;

                        update sarbox_instance_syspriv
                        set   dropped        = 'NO'
                        ,     dtdropped      = null
                        where instance       = upper(r_db_link.instance)
                        and   grantee        = w_syspriv_grantee
                        and   privilege      = w_syspriv_privilege;

                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert into sarbox_instance_syspriv
                                 (instance, grantee, privilege, admin_option, dropped, dtdropped)
                              values
                                 (upper(r_db_link.instance), w_syspriv_grantee, w_syspriv_privilege, w_syspriv_admin_option, 'NO', null);
                        end if;

                     end loop;
                     commit;
                     close c_sysprivs;
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_syspriv drop storage';
                     execute immediate w_sql;
                  end if;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'130 - Carga de sys privs');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;


                  /*
                  ** carregar logins da instance
                  */
                  if nvl(upper(r_db_link.search_trace), 'Y') = 'Y' then
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_login drop storage';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'insert into pcsox.sarbox_temp_instance_login select distinct '||chr(39)||upper(r_db_link.instance)||chr(39)||' instance, nvl(d4cusora, '||chr(39)||'NA'||chr(39)||') username, nvl(d4cprogr, '||chr(39)||'NA'||chr(39)||') program, nvl(d4cususo, '||chr(39)||'NA'||chr(39)||') userso, nvl(d4cmaqui, '||chr(39)||'NA'||chr(39)||') machine from bdtrace.d4cmolot@'||r_db_link.instance||'_sarbox where d4cdalog > trunc(last_day(add_months(sysdate, -6)))';
                     execute immediate w_sql;
                     w_sql := '';
                     w_sql := 'select distinct username, program, userso, machine from pcsox.sarbox_temp_instance_login where instance = '||chr(39)||upper(r_db_link.instance)||chr(39);
                     w_commit:= 0;
                     open c_login for w_sql;
                     loop
                        fetch c_login into w_login_username, w_login_program, w_login_userso, w_login_machine;
                        exit when c_login%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;
                        begin
                           insert
                              into sarbox_instance_login
                                 (instance, username, program, userso, machine)
                              values
                                 (upper(r_db_link.instance), w_login_username, w_login_program, w_login_userso, w_login_machine);
                        exception
                           when dup_val_on_index then null;
                        end;
                     end loop;
                     commit;
                     close c_login;
                     w_sql := 'truncate table pcsox.sarbox_temp_instance_login drop storage';
                     execute immediate w_sql;
                  end if;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'140 - Carga de logins');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** carregar dados de export - edvar 01/11/2007
                  */
                  -- faz a carga
                  begin
                     w_sql := 'select instance, connect_string, priority, createuser from sarbox_mapping_idm@'||r_db_link.instance||'_sarbox';
                     w_commit:= 0;
                     open c_mapidm for w_sql;
                     loop
                        fetch c_mapidm into w_idm_instance_source, w_idm_connect_string, w_idm_priority, w_idm_createuser;
                        exit when c_mapidm%notfound;
                        if w_commit = 500 then
                           commit;
                           w_commit := 0;
                        end if;
                        w_commit := w_commit + 1;
                        update sarbox_instance_idm
                        set connect_string   = w_idm_connect_string
                        ,   priority         = w_idm_priority
                        ,   createuser       = w_idm_createuser
                        where instance       = upper(r_db_link.instance)
                        and   instance_source= w_idm_instance_source;
                        if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                           insert
                              into sarbox_instance_idm
                                 (instance, instance_source, connect_string, priority, createuser)
                              values
                                 (upper(r_db_link.instance), w_idm_instance_source, w_idm_connect_string, w_idm_priority, w_idm_createuser);
                        end if;
                     end loop;
                     commit;
                     close c_mapidm;
                  exception
                     when others then
                        if sqlcode = -942 then
                           null;
                        end if;
                  end;

                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'150 - Carga de export');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;

                  /*
                  ** carregar jobs da instance - edvar 01/11/2007
                  */
                  -- marca todos os jobs como excluido
                  w_datetimeproc := sysdate;
                  for r_job_ex in (select rowid from sarbox_instance_job where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_job
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_job_ex.rowid;
                  end loop;
                  commit;

                  -- faz a carga
                  w_sql := 'select job,log_user,priv_user,schema_user,last_date,last_sec,this_date,this_sec,next_date,next_sec,total_time,broken,interval,failures,what,nls_env,misc_env,instance from dba_jobs@'||r_db_link.instance||'_sarbox';
                  w_commit:= 0;
                  open c_job for w_sql;
                  loop
                     fetch c_job into w_job_job,w_job_log_user,w_job_priv_user,w_job_schema_user,w_job_last_date,w_job_last_sec,w_job_this_date,w_job_this_sec,w_job_next_date,w_job_next_sec,w_job_total_time,w_job_broken,w_job_interval,w_job_failures,w_job_what,w_job_nls_env,w_job_misc_env,w_job_instance_id;
                     exit when c_job%notfound;
                     if w_commit = 500 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;
                     update sarbox_instance_job
                     set    last_date     = w_job_last_date
                     ,      last_sec      = w_job_last_sec
                     ,      this_date     = w_job_this_date
                     ,      this_sec      = w_job_this_sec
                     ,      next_date     = w_job_next_date
                     ,      next_sec      = w_job_next_sec
                     ,      total_time    = w_job_total_time
                     ,      broken        = w_job_broken
                     ,      interval      = w_job_interval
                     ,      failures      = w_job_failures
                     ,      what          = w_job_what
                     ,      nls_env       = w_job_nls_env
                     ,      misc_env      = w_job_misc_env
                     ,      instance_id   = w_job_instance_id
                     ,      dropped       = 'NO'
                     ,      dtdropped     = null
                     where  instance      = upper(r_db_link.instance)
                     and    job           = w_job_job
                     and    log_user      = w_job_log_user
                     and    priv_user     = w_job_priv_user
                     and    schema_user   = w_job_schema_user;
                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_job
                              (instance, job, log_user, priv_user, schema_user, last_date, last_sec, this_date, this_sec, next_date, next_sec, total_time, broken, interval, failures, what, nls_env, misc_env, instance_id, dropped, dtdropped, dtinsert)
                           values
                              (upper(r_db_link.instance), w_job_job, w_job_log_user, w_job_priv_user, w_job_schema_user, w_job_last_date, w_job_last_sec, w_job_this_date, w_job_this_sec, w_job_next_date, w_job_next_sec, w_job_total_time, w_job_broken, w_job_interval, w_job_failures, w_job_what, w_job_nls_env, w_job_misc_env, w_job_instance_id, 'NO', null, trunc(sysdate));
                     end if;

                  end loop;
                  commit;
                  close c_job;

                  /*
                  ** carregar sinônimos remotos da instance - edvar 21/12/2011
                  */
                  -- marca todos os sinônimos como excluido
                  w_datetimeproc := sysdate;
                  for r_syn_ex in (select rowid from sarbox_instance_synonym where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_synonym
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_syn_ex.rowid;
                  end loop;
                  commit;

                  -- faz a carga
                  w_sql := 'select owner,synonym_name,table_owner,table_name,db_link from dba_synonyms@'||r_db_link.instance||'_sarbox where db_link is not null';
                  w_commit:= 0;
                  open c_syn for w_sql;
                  loop
                     fetch c_syn into w_syn_owner,w_syn_synonym_name,w_syn_table_owner,w_syn_table_name,w_syn_db_link;
                     exit when c_syn%notfound;
                     if w_commit = 5000 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;

                     update sarbox_instance_synonym
                     set    table_owner   = w_syn_table_owner
                     ,      table_name    = w_syn_table_name
                     ,      db_link       = w_syn_db_link
                     ,      dropped       = 'NO'
                     ,      dtdropped     = null
                     where  instance      = upper(r_db_link.instance)
                     and    owner         = w_syn_owner
                     and    synonym_name  = w_syn_synonym_name;
                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_synonym
                              (instance, owner, synonym_name, table_owner, table_name, db_link, dropped, dtdropped, dtinsert)
                           values
                              (upper(r_db_link.instance), w_syn_owner, w_syn_synonym_name, w_syn_table_owner, w_syn_table_name, w_syn_db_link, 'NO', null, trunc(sysdate));
                     end if;
                  end loop;
                  commit;
                  close c_syn;

                  /*
                  ** carregar snapshots da instance - edvar 22/12/2011
                  */
                  -- marca todos os sinônimos como excluido
                  w_datetimeproc := sysdate;
                  for r_snap_ex in (select rowid from sarbox_instance_snapshot where upper(instance) = upper(r_db_link.instance) and dropped <> 'YES')
                  loop
                     update sarbox_instance_snapshot
                     set    dropped   = 'YES'
                     ,      dtdropped = w_datetimeproc
                     where rowid = r_snap_ex.rowid;
                  end loop;
                  commit;

                  -- faz a carga
                  w_sql := 'select owner,name,table_name,master_view,master_owner,master,master_link,can_use_log,updatable,refresh_method,last_refresh,error,fr_operations,cr_operations,type,next,start_with,refresh_group,update_trig,update_log,query,master_rollback_seg,status,refresh_mode,prebuilt from dba_snapshots@'||r_db_link.instance||'_sarbox';
                  w_commit:= 0;
                  open c_snap for w_sql;
                  loop
                     fetch c_snap into w_snap_owner, w_snap_name, w_snap_table_name, w_snap_master_view, w_snap_master_owner, w_snap_master, w_snap_master_link, w_snap_can_use_log, w_snap_updatable, w_snap_refresh_method, w_snap_last_refresh, w_snap_error, w_snap_fr_operations, w_snap_cr_operations, w_snap_type, w_snap_next, w_snap_start_with, w_snap_refresh_group, w_snap_update_trig, w_snap_update_log, w_snap_query, w_snap_master_rollback_seg, w_snap_status, w_snap_refresh_mode, w_snap_prebuilt;
                     exit when c_snap%notfound;
                     if w_commit = 5000 then
                        commit;
                        w_commit := 0;
                     end if;
                     w_commit := w_commit + 1;

                     update sarbox_instance_snapshot
                     set    master_view         = w_snap_master_view
                     ,      master_owner        = w_snap_master_owner
                     ,      master              = w_snap_master
                     ,      master_link         = w_snap_master_link
                     ,      can_use_log         = w_snap_can_use_log
                     ,      updatable           = w_snap_updatable
                     ,      refresh_method      = w_snap_refresh_method
                     ,      last_refresh        = w_snap_last_refresh
                     ,      error               = w_snap_error
                     ,      fr_operations       = w_snap_fr_operations
                     ,      cr_operations       = w_snap_cr_operations
                     ,      type                = w_snap_type
                     ,      next                = w_snap_next
                     ,      start_with          = w_snap_start_with
                     ,      refresh_group       = w_snap_refresh_group
                     ,      update_trig         = w_snap_update_trig
                     ,      update_log          = w_snap_update_log
                     ,      query               = w_snap_query
                     ,      master_rollback_seg = w_snap_master_rollback_seg
                     ,      status              = w_snap_status
                     ,      refresh_mode        = w_snap_refresh_mode
                     ,      prebuilt            = w_snap_prebuilt
                     ,      dropped             = 'NO'
                     ,      dtdropped           = null
                     where  instance            = upper(r_db_link.instance)
                     and    owner               = w_snap_owner
                     and    name                = w_snap_name
                     and    table_name          = w_snap_table_name;

                     if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                        insert
                           into sarbox_instance_snapshot
                              (instance, owner, name, table_name, master_view, master_owner, master, master_link, can_use_log, updatable, refresh_method, last_refresh, error, fr_operations, cr_operations, type, next, start_with, refresh_group, update_trig, update_log, query, master_rollback_seg, status, refresh_mode, prebuilt, dropped, dtdropped, dtinsert)
                           values
                              (upper(r_db_link.instance), w_snap_owner, w_snap_name, w_snap_table_name, w_snap_master_view, w_snap_master_owner, w_snap_master, w_snap_master_link, w_snap_can_use_log, w_snap_updatable, w_snap_refresh_method, w_snap_last_refresh, w_snap_error, w_snap_fr_operations, w_snap_cr_operations, w_snap_type, w_snap_next, w_snap_start_with, w_snap_refresh_group, w_snap_update_trig, w_snap_update_log, w_snap_query, w_snap_master_rollback_seg, w_snap_status, w_snap_refresh_mode, w_snap_prebuilt, 'NO', null, trunc(sysdate));
                     end if;
                  end loop;
                  commit;
                  close c_snap;
                  
                  if adddebuginfo = true then
                     /*
                     ** log de execução
                     */
                     w_debug_dtend     := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                     insert into pcsox.sarbox_debug values ('Instance: '||upper(r_db_link.instance)||' -  Start: '||w_debug_dtstart||' - End: '||w_debug_dtend||' - Task: '||'160 - Carga de links');
                     w_debug_dtstart   := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
                  end if;
               end if;

               /*
               ** finalização do processo
               */
               update  sarbox_instance
               set     status       = 'OK'
               ,       message      = w_linha_log || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') || '. Informações coletadas com sucesso.'
               ,       errorm       = null
               ,       statement    = null
               where   instance = r_db_link.instance;
               commit;
            exception
               when others then
                  w_erro_message   := substr(sqlerrm, 1, 400);
                  w_erro_statement := substr(replace(w_sql, pak_sox00001.ctv(w_ws), ''), 1, 400);
                  update  sarbox_instance
                  set     status       = 'NOK'
                  ,       message      = w_linha_log || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') || '. Processo finalizado com erro.'
                  ,       errorm       = w_erro_message
                  ,       statement    = w_erro_statement
                  where   instance = r_db_link.instance;
                  commit;
            end;

            /*
            ** excluir o db_link
            */
            begin
               w_sql := 'ALTER SESSION CLOSE DATABASE LINK '||r_db_link.instance||'_SARBOX';
               execute immediate (w_sql);
               w_sql := 'DROP DATABASE LINK '||r_db_link.instance||'_sarbox';
               execute immediate (w_sql);
            exception
               when others then
                  if sqlcode = -2081 then
                     w_sql := 'DROP DATABASE LINK '||r_db_link.instance||'_sarbox';
                     execute immediate (w_sql);
                  else
                     null;
                  end if;
            end;
         end if;
      end loop;
      commit;

      verifica_termino_carga(p_instance, p_email, p_notify);
      /*
      ** faz a verificação do termino da carga
      */
      -- select count(*)
      -- into   w_erro_carga
      -- from   sarbox_instance
      -- where  upper(search) = 'Y'
      -- and    notify like upper(p_notify)
      -- and    ((status = 'NOK') or (startup_time >= trunc(sysdate-1)+1/24) or (server_instances <> server_instances_active) or (file_autoextensible <> 0)) and instance <> 'ORADMVS' and upper(instance) like upper('%'||p_instance||'%');

      -- if w_erro_carga <> 0 then
         -- /* ocorreu erro na carga - irá enviar email*/
         -- w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
         -- utl_smtp.helo(w_mailconn, w_mailhost);
         -- utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
         -- if p_email is null then
            -- utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
            -- utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
         -- else
            -- utl_smtp.rcpt(w_mailconn, p_email);
         -- end if;

         -- utl_smtp.open_data(w_mailconn);
         -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
         -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
         -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
         -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'COLETA SARBOX - Erro no processo de coleta'||w_crlf));
         -- -- problema na carga
         -- w_printcabec := 0;
         -- for r_coleta_erro in (select instance, errorm, rownum from sarbox_instance where  upper(search) = 'Y' and status = 'NOK' and notify like upper(p_notify))
         -- loop
            -- if r_coleta_erro.rownum = 1 then
               -- w_printcabec := 1;
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentaram falhas durante o processo de coleta:'||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            -- end if;
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - '||r_coleta_erro.instance||' - ERRO: '||r_coleta_erro.errorm||w_crlf));
         -- end loop;

         -- if w_printcabec = 1 then
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Maiores detalhes na entidade SARBOX_INSTANCE.'||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Para a(s) instance(s) acima as informações estão inconsistentes.'||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - não utilizar a procedure da package pak_sox00001.CHANGE_PASS;'||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - levantamentos usando as tabelas do PCSOX estarão inconsistentes.'||w_crlf));
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         -- end if;

         -- -- instances com startup
         -- for r_startup in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||rpad(nvl(to_char(startup_time, 'dd/mm/yyyy hh24:mi:ss'), ' '),22) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and startup_time >= trunc(sysdate-1)+1/24 and instance <> 'ORADMVS' and notify like upper(p_notify))
         -- loop
            -- if r_startup.rownum = 1 then
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) foram reiniciadas após '||to_char(trunc(sysdate-1)+1/24, 'dd/mm/yyyy hh24:mi:ss') ||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||rpad(nvl('Startup Time', ' '),22)||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ----------------------'||w_crlf));
            -- end if;
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_startup.linhalog||w_crlf));
         -- end loop;

         -- -- instances com indisponibilidade de no
         -- for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(server_instances, 10)||' '||lpad(server_instances_active, 11) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and server_instances <> server_instances_active and instance <> 'ORADMVS' and notify like upper(p_notify))
         -- loop
            -- if r_norac.rownum = 1 then
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam indisponibilidade de nó RAC:'||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total Inst', 10)||' '||lpad('Active Inst', 11)||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ---------- -----------'||w_crlf));
            -- end if;
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
         -- end loop;

         -- -- instances com files em AUTOEXTENSIBLE=YES
         -- for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(file_autoextensible, 22) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and file_autoextensible <> 0 and notify like upper(p_notify))
         -- loop
            -- if r_norac.rownum = 1 then
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam arquivos AUTOEXTENSIBLE=YES:'||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total AUTOEXTEND ON', 22)||w_crlf));
               -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ----------------------'||w_crlf));
            -- end if;
            -- utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
         -- end loop;

         -- utl_smtp.close_data(w_mailconn);
         -- utl_smtp.quit(w_mailconn);
      -- end if;
      
      /*
      ** envio de nota com instance com falha no job de sincronismo de senha
      */
      for r_jobsync in (select sij.instance, sij.job, rownum from sarbox_instance si, sarbox_instance_job sij where si.instance = sij.instance and si.search = 'Y' and sij.schema_user = 'PCSOX' and sij.failures <> 0 and lower(sij.what) = 'begin stp_sox00001_altercreateidm; end;' and sij.dropped = 'NO')
      loop
         if r_jobsync.rownum = 1 then
            w_sendmailsync := 'S';
            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
            utl_smtp.helo(w_mailconn, w_mailhost);
            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
            if p_email is null then
               utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
               utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
            else
               utl_smtp.rcpt(w_mailconn, p_email);
            end if;

            utl_smtp.open_data(w_mailconn);
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX - Falha no job de sincronismo de senha'||w_crlf));

            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam falha na execução no job de sicronismo de senha:'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Para reativar o job: conectar com o usuário PCSOX e executar o job e verificar possíveis mensagens de erro.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         end if;
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('@sox '||lower(r_jobsync.instance)||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('exec dbms_job.run('||r_jobsync.job||')'||w_crlf||w_crlf));
      end loop;
      if w_sendmailsync = 'S' then
         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

      w_coleta_ended := to_char(sysdate, 'dd/mm/rrrr hh24:mi:ss');
      grava_log(upper('PR_COLETA_SARBOX'), 'COLETA_SARBOX', 'LOG', to_char(sysdate, 'YYYYMMDD')||' - (Parameters: PI=> '||p_instance||' PF=> '||nvl(p_full, '-')||' PE=> '||nvl(p_email, '-')||' PN=> '||nvl(p_notify, '-')||')', w_coleta_started, w_coleta_ended);
      commit;

   end coleta_sarbox;
   
   procedure verifica_disp_instancia(p_instancia in varchar2)
   is
      /* variaveis globlais */
      w_sql                      varchar2(4000);
      w_linha_log                varchar2(4000);
      w_commit                   number;
      w_erro_message             varchar2(400);
      w_errordt                  date;
      w_errorcount               number;
      w_pos1                     number;
      w_len1                     number;
      w_instnm                   varchar2(15);
      w_connect_string           sarbox_instance.connect_string%type;
      
      /* dados da instance */
      w_inst_version             sarbox_instance.version%type;
      w_inst_host                sarbox_instance.hostname%type;
      w_inst_startup             sarbox_instance.startup_time%type;
      w_inst_instnum             sarbox_instance.instance_number%type;
      w_inst_status              sarbox_instance.status%type;
      w_inst_lang                varchar2(100);
      w_inst_terr                varchar2(100);
      w_inst_cs                  varchar2(100);
      w_inst_nls                 varchar2(100);
      w_inst_size                number;
      w_erro_carga_vd            number;
      w_inst_sessions_current    sarbox_instance.sessions_current%type;
      w_inst_sessions_highwater  sarbox_instance.sessions_highwater%type;
      w_inst_cpu_count_current   sarbox_instance.cpu_count_current%type;
      w_inst_cpu_count_highwater sarbox_instance.cpu_count_highwater%type;
      w_inst_fixed_size          sarbox_instance.fixed_size%type;
      w_inst_variable_size       sarbox_instance.variable_size%type;
      w_inst_database_buffers    sarbox_instance.database_buffers%type;
      w_inst_redo_buffers        sarbox_instance.redo_buffers%type;
      w_inst_created             sarbox_instance.created%type;
      w_inst_resetlogs_time      sarbox_instance.resetlogs_time%type;
      w_inst_cf_created          sarbox_instance.controlfile_created%type;
      w_inst_cf_time             sarbox_instance.controlfile_time%type;
      w_inst_version_time        sarbox_instance.version_time%type;
      w_inst_platform_id         sarbox_instance.platform_id%type;
      w_inst_platform_name       sarbox_instance.platform_name%type;
      w_inst_rec_incarnation     sarbox_instance.recovery_target_incarnation#%type;
      w_inst_last_incarnation    sarbox_instance.last_open_incarnation#%type;
      w_inst_serverinst          sarbox_instance.server_instances%type;
      w_inst_serverinst_act      sarbox_instance.server_instances_active%type;
      w_inst_logmode             sarbox_instance.log_mode%type;
      w_inst_nls_length_semantic varchar2(100);
      w_inst_nls_nchar_cs        varchar2(100);

      /* cursor de export */
      w_exp_idprc                sarbox_instance_export.id_process%type;
      w_exp_start                sarbox_instance_export.started%type;
      w_exp_end                  sarbox_instance_export.ended%type;
      w_exp_status               sarbox_instance_export.status%type;
      w_filename                 sarbox_instance_export.filename%type;
      w_filesize                 sarbox_instance_export.filesize%type;
      w_message_ora              sarbox_instance_export.message_ora%type;
      w_message_exp              sarbox_instance_export.message_exp%type;

      /* cursor de startup */
      w_start_startup_time       sarbox_instance_startup.startup_time%type;

      w_start_instance_id        sarbox_instance_startup.instance_id%type;
      w_start_instance_name      sarbox_instance_startup.instance_name%type;
      w_start_user_oracle        sarbox_instance_startup.user_oracle%type;
      w_start_user_so            sarbox_instance_startup.user_so%type;
      w_start_terminal           sarbox_instance_startup.terminal%type;
      w_start_operation          sarbox_instance_startup.operation%type;
      w_start_host_name          sarbox_instance_startup.host_name%type;
      w_start_version            sarbox_instance_startup.version%type;
      w_start_status             sarbox_instance_startup.status%type;
      w_start_archiver           sarbox_instance_startup.archiver%type;
      w_start_logins             sarbox_instance_startup.logins%type;
      w_start_database_status    sarbox_instance_startup.database_status%type;
      w_start_archive_mode       sarbox_instance_startup.archive_mode%type;
      w_start_dtstartup          sarbox_instance_startup.dtstartup%type;
      w_start_dtshutdown         sarbox_instance_startup.dtshutdown%type;

      /* sysstats */
      w_ht_logicalread           sarbox_instance.logical_reads%type;
      w_ht_physicalread          sarbox_instance.physical_reads%type;
      w_ht_physicalwrite         sarbox_instance.physical_writes%type;
      w_ht_db_buffer             sarbox_instance.hit_ratio_buffer%type;

      /* row cache */
      w_ht_dictget               sarbox_instance.rc_gets%type;
      w_ht_dictmisses            sarbox_instance.rc_getmisses%type;
      w_ht_cache                 sarbox_instance.hit_ratio_library_cache%type;

      /* library cache */
      w_ht_lbcexecs              sarbox_instance.lbc_pins%type;
      w_ht_lbcmisseswe           sarbox_instance.lbc_reloads%type;
      w_ht_lbcache               sarbox_instance.hit_hatio_cachemiss%type;

      /* declaracao de handle de cursor */
      type rc is ref cursor;
      c_export    rc;
      c_start     rc;
      
   begin
      w_linha_log := '';
      w_linha_log := to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')||' - ';
      /*
      ** criar db_links
      */
      begin
         select connect_string
         into w_connect_string
         from sarbox_instance
         where upper(instance) = upper(p_instancia);
         w_sql := 'create database link '||p_instancia||'_sarbox_vd '||pak_sox00001.ctv(w_ws)||' using '||chr(39)||w_connect_string||chr(39);
         execute immediate (w_sql);
      exception
         when others then null;
      end;
      begin
         w_errordt      := sysdate;
         w_errorcount   := 0;
         /*
         **
         */
         execute immediate 'select version, host_name, startup_time, instance_number from v$instance@'||p_instancia||'_sarbox_vd' into w_inst_version, w_inst_host, w_inst_startup, w_inst_instnum;
         execute immediate 'select sum(bytes)/1024 bytes from (select sum(bytes) bytes from dba_data_files@'||p_instancia||'_sarbox_vd union select sum(bytes) bytes from dba_temp_files@'||p_instancia||'_sarbox_vd union select sum(bytes) bytes from v$log@'||p_instancia||'_sarbox_vd)' into w_inst_size;
         execute immediate 'select value nl from nls_database_parameters@'||p_instancia||'_sarbox_vd where parameter = '||chr(39)||'NLS_LANGUAGE'||chr(39)             into w_inst_lang;
         execute immediate 'select value nt from nls_database_parameters@'||p_instancia||'_sarbox_vd where parameter = '||chr(39)||'NLS_TERRITORY'||chr(39)            into w_inst_terr;
         execute immediate 'select value nc from nls_database_parameters@'||p_instancia||'_sarbox_vd where parameter = '||chr(39)||'NLS_CHARACTERSET'||chr(39)         into w_inst_cs;
         execute immediate 'select value nc from nls_database_parameters@'||p_instancia||'_sarbox_vd where parameter = '||chr(39)||'NLS_NCHAR_CHARACTERSET'||chr(39)   into w_inst_nls_nchar_cs;
         execute immediate 'select value ps from v$parameter@'||p_instancia||'_sarbox_vd where name = '||chr(39)||'parallel_server_instances'||chr(39)                 into w_inst_serverinst;
         execute immediate 'select count(1) cnt from gv$instance@'||p_instancia||'_sarbox_vd'                                                                          into w_inst_serverinst_act;
         execute immediate 'select value nl from v$sga@'||p_instancia||'_sarbox_vd where name = '||chr(39)||'Fixed Size'||chr(39)                                      into w_inst_fixed_size;
         execute immediate 'select value nl from v$sga@'||p_instancia||'_sarbox_vd where name = '||chr(39)||'Variable Size'||chr(39)                                   into w_inst_variable_size;
         execute immediate 'select value nl from v$sga@'||p_instancia||'_sarbox_vd where name = '||chr(39)||'Database Buffers'||chr(39)                                into w_inst_database_buffers;
         execute immediate 'select value nl from v$sga@'||p_instancia||'_sarbox_vd where name = '||chr(39)||'Redo Buffers'||chr(39)                                    into w_inst_redo_buffers;
         execute immediate 'select log_mode from v$database@'||p_instancia||'_sarbox_vd'                                                                               into w_inst_logmode;

         /*
         ** valores de hit ratio
         */
         execute immediate 'select a.value + b.value lr,c.value  pr,d.value  pw,round(100 * ((a.value+b.value)-c.value)/(a.value+b.value)) d_buffer_hr from v$sysstat@'||p_instancia||'_sarbox_vd a, v$sysstat@'||p_instancia||'_sarbox_vd b, v$sysstat@'||p_instancia||'_sarbox_vd c, v$sysstat@'||p_instancia||'_sarbox_vd d where a.name ='||chr(39)||'db block gets'||chr(39)||' and b.name ='||chr(39)||'consistent gets'||chr(39)||' and c.name ='||chr(39)||'physical reads'||chr(39)||' and d.name ='||chr(39)||'physical writes'||chr(39) into w_ht_logicalread, w_ht_physicalread, w_ht_physicalwrite, w_ht_db_buffer;
         execute immediate 'select sum(gets) dd_get, sum(getmisses) dd_getmis, trunc((1-(sum(getmisses)/sum(gets)))*100) d_cache_hr from v$rowcache@'||p_instancia||'_sarbox_vd'   into w_ht_dictget, w_ht_dictmisses, w_ht_cache;
         execute immediate 'select sum(pins) exec, sum(reloads) reload,(((sum(reloads)/sum(pins)))) l_cachemis_hr from v$librarycache@'||p_instancia||'_sarbox_vd'                 into w_ht_lbcexecs, w_ht_lbcmisseswe, w_ht_lbcache;

         w_inst_sessions_current       := 0;
         w_inst_sessions_highwater     := 0;
         w_inst_cpu_count_current      := 0;
         w_inst_cpu_count_highwater    := 0;
         begin
            execute immediate 'select sessions_current, sessions_highwater, cpu_count_current, cpu_count_highwater from v$license@'||p_instancia||'_sarbox_vd'      into w_inst_sessions_current, w_inst_sessions_highwater, w_inst_cpu_count_current, w_inst_cpu_count_highwater;
         exception
            when others then
            execute immediate 'select sessions_current, sessions_highwater, null ccc, null cch from v$license@'||p_instancia||'_sarbox_vd'      into w_inst_sessions_current, w_inst_sessions_highwater, w_inst_cpu_count_current, w_inst_cpu_count_highwater;
         end;

         begin
            execute immediate 'select created, resetlogs_time, controlfile_created, controlfile_time, version_time, platform_id, platform_name, recovery_target_incarnation#, last_open_incarnation# from v$database@'||p_instancia||'_sarbox_vd' into w_inst_created, w_inst_resetlogs_time, w_inst_cf_created, w_inst_cf_time, w_inst_version_time, w_inst_platform_id, w_inst_platform_name, w_inst_rec_incarnation, w_inst_last_incarnation;
         exception
            when others then
            execute immediate 'select created, resetlogs_time, controlfile_created, controlfile_time, version_time, null pltid, null pltnm, null rti, null loi from v$database@'||p_instancia||'_sarbox_vd' into w_inst_created, w_inst_resetlogs_time, w_inst_cf_created, w_inst_cf_time, w_inst_version_time, w_inst_platform_id, w_inst_platform_name, w_inst_rec_incarnation, w_inst_last_incarnation;
         end;

         begin
            execute immediate 'select value nc from nls_database_parameters@'||p_instancia||'_sarbox_vd where parameter = '||chr(39)||'NLS_LENGTH_SEMANTICS'||chr(39)     into w_inst_nls_length_semantic;
         exception
            when others then
            w_inst_nls_length_semantic := 'NA';
         end;

         if w_ht_db_buffer < 0 then
            w_ht_db_buffer := 0;
         end if;

         update  sarbox_instance
         set     version                        = w_inst_version
         ,       startup_time                   = w_inst_startup
         ,       instance_number                = w_inst_instnum
         ,       hostname                       = w_inst_host
         ,       cs                             = w_inst_lang||'_'||w_inst_terr||'.'||w_inst_cs
         ,       nls_nchar_cs                   = w_inst_nls_nchar_cs
         ,       nls_length_semantics           = w_inst_nls_length_semantic
         ,       vstatus                        = 'NA'
         ,       vmessage                       = 'Processo iniciado em '||to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss')
         ,       verrorm                        = null
         ,       ksize                          = w_inst_size
         ,       sessions_current               = w_inst_sessions_current
         ,       sessions_highwater             = w_inst_sessions_highwater
         ,       cpu_count_current              = w_inst_cpu_count_current
         ,       cpu_count_highwater            = w_inst_cpu_count_highwater
         ,       fixed_size                     = w_inst_fixed_size
         ,       variable_size                  = w_inst_variable_size
         ,       database_buffers               = w_inst_database_buffers
         ,       redo_buffers                   = w_inst_redo_buffers
         ,       created                        = w_inst_created
         ,       resetlogs_time                 = w_inst_resetlogs_time
         ,       controlfile_created            = w_inst_cf_created
         ,       controlfile_time               = w_inst_cf_time
         ,       version_time                   = w_inst_version_time
         ,       platform_id                    = w_inst_platform_id
         ,       platform_name                  = w_inst_platform_name
         ,       recovery_target_incarnation#   = w_inst_rec_incarnation
         ,       last_open_incarnation#         = w_inst_last_incarnation
         ,       server_instances               = w_inst_serverinst
         ,       server_instances_active        = w_inst_serverinst_act
         ,       logical_reads                  = w_ht_logicalread
         ,       physical_reads                 = w_ht_physicalread
         ,       physical_writes                = w_ht_physicalwrite
         ,       hit_ratio_buffer               = w_ht_db_buffer
         ,       rc_gets                        = w_ht_dictget
         ,       rc_getmisses                   = w_ht_dictmisses
         ,       hit_ratio_library_cache        = w_ht_cache
         ,       lbc_pins                       = w_ht_lbcexecs
         ,       lbc_reloads                    = w_ht_lbcmisseswe
         ,       hit_hatio_cachemiss            = w_ht_lbcache
         ,       log_mode                       = w_inst_logmode
         where   instance = p_instancia;
         commit;

         /*
         ** carregar dados de export
         */
         -- faz a carga
         begin
            w_sql := 'select d4nidprc, d4nstart, d4nendpc, d4nstats, d4nfsize, d4nmerro, d4nmerre, d4nfname from d4nlexpt@'||p_instancia||'_sarbox_vd where d4nstart >= trunc(sysdate)-5';
            w_commit:= 0;
            open c_export for w_sql;
            loop
               fetch c_export into w_exp_idprc, w_exp_start, w_exp_end, w_exp_status, w_filesize, w_message_ora, w_message_exp, w_filename;
               exit when c_export%notfound;
               w_pos1   := 0;
               w_len1   := 0;
               w_pos1   := instr(w_exp_idprc, '_') + 1;
               w_len1   := instr(w_exp_idprc, '_', -1) - w_pos1;
               w_instnm := upper(substr(w_exp_idprc, w_pos1, w_len1));
               --dbms_output.put_line('P1 - '||p_instancia||' - '||w_instnm||' - '||instr(upper(p_instancia), w_instnm));
               if instr(upper(p_instancia), w_instnm) <> 0 then
                  --dbms_output.put_line('P2 - '||p_instancia||' - '||w_instnm);
                  if w_commit = 500 then
                     commit;
                     w_commit := 0;
                  end if;
                  w_commit := w_commit + 1;
                  update sarbox_instance_export
                  set started          = w_exp_start
                  ,   ended            = w_exp_end
                  ,   status           = w_exp_status
                  ,   filesize         = w_filesize
                  ,   message_ora      = w_message_ora
                  ,   message_exp      = w_message_exp
                  ,   filename         = w_filename
                  where instance       = upper(p_instancia)
                  and   id_process     = w_exp_idprc;
                  if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                     insert
                        into sarbox_instance_export
                           (instance, id_process, started, ended, status, exptype, filesize, message_ora, message_exp, filename)
                        values
                           (upper(p_instancia), w_exp_idprc, w_exp_start, w_exp_end, w_exp_status, substr(w_exp_status, 1 , instr(w_exp_status, ':')-1), w_filesize, w_message_ora, w_message_exp, w_filename);
                  end if;
               end if;
            end loop;
            commit;
            close c_export;
         exception
            when others then
               if sqlcode = -942 then
                  null;
               end if;
         end;

         /*
         ** carregar dados de startup
         */
         -- faz a carga
         --dbms_output.put_line(upper(r_db_link.instance));
         begin
            w_sql := 'select d4odalog, d4oinstd, d4odbnam, d4ousora, d4oususo, d4omaqui, d4oopera, d4ohostn, d4oversn, d4ostatu, d4oarchv, d4ologin, d4odbsts, d4oarchm, d4osttdt, d4oshtdt from d4ostart@'||p_instancia||'_sarbox_vd where d4oshtdt >= trunc(sysdate)-3';
            w_commit:= 0;
            open c_start for w_sql;
            loop
               fetch c_start into w_start_startup_time, w_start_instance_id, w_start_instance_name, w_start_user_oracle, w_start_user_so, w_start_terminal, w_start_operation, w_start_host_name, w_start_version, w_start_status, w_start_archiver, w_start_logins, w_start_database_status, w_start_archive_mode, w_start_dtstartup, w_start_dtshutdown;
               exit when c_start%notfound;
               if instr(upper(w_start_instance_name), upper(replace(p_instancia, 'ORA', ''))) <> 0 then
                  if w_commit = 500 then
                     commit;
                     w_commit := 0;
                  end if;
                  w_commit := w_commit + 1;
                  --dbms_output.put_line(upper(r_db_link.instance)||' - '||to_char(w_start_startup_time, 'dd/mm/yyyy hh24:mi:ss'));
                  update sarbox_instance_startup
                  set    dtshutdown    = w_start_dtshutdown
                  where  instance      = upper(p_instancia)
                  and    startup_time  = w_start_startup_time;

                  if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
                     insert
                        into sarbox_instance_startup
                           ( instance,                   startup_time,              instance_id
                           , instance_name,              user_oracle,               user_so
                           , terminal,                   operation,                 host_name
                           , version,                    status,                    archiver
                           , logins,                     database_status,           archive_mode
                           , dtstartup,                  dtshutdown
                           )
                        values
                           ( upper(p_instancia),  w_start_startup_time,      w_start_instance_id
                           , w_start_instance_name,      w_start_user_oracle,       w_start_user_so
                           , w_start_terminal,           w_start_operation,         w_start_host_name
                           , w_start_version,            w_start_status,            w_start_archiver
                           , w_start_logins,             w_start_database_status,   w_start_archive_mode
                           , w_start_dtstartup,          w_start_dtshutdown
                           );
                  end if;
               end if;
            end loop;
            commit;
            close c_start;
         exception
            when dup_val_on_index then null;
            when others then
               if sqlcode = -942 then
                  null;
               end if;
         end;

         /*
         ** finalização do processo
         */
         update  sarbox_instance
         set     vstatus      = 'OK'
         ,       vmessage     = w_linha_log || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') || '. Informações coletadas com sucesso.'
         ,       verrorm      = null
         ,       verrordt     = sysdate
         ,       verrorcount  = 0
         where   instance = p_instancia;
         commit;
      exception
         when others then
            select  verrordt, nvl(verrorcount, 0) verrorcount
            into    w_errordt, w_errorcount
            from    sarbox_instance
            where   instance = p_instancia;
            if trunc(nvl(w_errordt, sysdate)) = trunc(sysdate) then
               w_errorcount := w_errorcount + 1;
            else
               w_errorcount := 0;
            end if;
            w_erro_message   := substr(sqlerrm, 1, 400);
            update  sarbox_instance
            set     vstatus      = 'NOK'
            ,       vmessage     = w_linha_log || to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') || '. Processo finalizado com erro.'
            ,       verrorm      = w_erro_message
            ,       verrordt     = sysdate
            ,       verrorcount  = w_errorcount
            where   instance = p_instancia;
            insert  into sarbox_instance_log
                    (instance, dtlog, verrorm)
            values
                    (p_instancia, sysdate, w_erro_message);
            commit;
      end;

      /*
      ** excluir o db_link
      */
      begin
         w_sql := 'ALTER SESSION CLOSE DATABASE LINK '||p_instancia||'_sarbox_vd';
         execute immediate (w_sql);
         w_sql := 'DROP DATABASE LINK '||p_instancia||'_sarbox_vd';
         execute immediate (w_sql);
      exception
         when others then
            if sqlcode = -2081 then
               w_sql := 'DROP DATABASE LINK '||p_instancia||'_sarbox_vd';
               execute immediate (w_sql);
            else
               null;
            end if;
      end;
   end verifica_disp_instancia;

   procedure verifica_disponibilidade(p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is
   
      NUM_JOBS_SIM_DEF constant pls_integer := 10;
      THRESHOLD_TOTAL constant number := 20 * 60; -- Em segundos
      THRESHOLD_PADRAO_JOB constant number := 5 * 60; -- Em segundos
      PREFIXO_JOB constant varchar2(11) := 'SOX_DISP_';

      w_nome_job user_scheduler_jobs.job_name%type;
      w_lista_jobs t_lista_jobs := t_lista_jobs();
      
      /* variaveis para controle de locks */
      w_lockhandle varchar2(4000);
      w_lock_status pls_integer;
      
      /* variaveis globlais */
      w_sql varchar2(4000);
      
      w_cnt pls_integer;

      cursor c_db_link is
         select * from sarbox_instance
         where  upper(search) = 'Y'
         order by priority;

   begin
      dbms_lock.allocate_unique(PREFIXO_JOB, w_lockhandle);
      w_lock_status := dbms_lock.request(w_lockhandle, DBMS_LOCK.X_MODE, 0, false);
      if w_lock_status <> 0 then
         raise_application_error(-20001, 'Já há verificação em execução');
      end if;
   
      for r_jobs in (select job_name from user_scheduler_jobs where job_name like PREFIXO_JOB||'%') loop
         begin
            dbms_scheduler.stop_job(r_jobs.job_name, true);
         exception when others then
            null;  -- erros na interrupcao de jobs podem ser ignorados neste ponto
         end;
         begin
            dbms_scheduler.drop_job(r_jobs.job_name, true);
         exception when others then
            null; -- erros na remocao de jobs podem ser ignorados neste ponto
         end;
      end loop;
   
      /*
      ** exclui db_links que ficaram perdidos em caso de erro.
      */
      for r_db in (select db_link from user_db_links)
      loop
         begin
            --dbms_output.put_line(r_db.db_link);
            w_sql := 'DROP DATABASE LINK '||r_db.db_link||'_sarbox_vd';
            execute immediate (w_sql);
         exception
            when others then null;
         end;
      end loop;

      update sarbox_instance
      set    vstatus  = 'WT-OK'
      ,      vmessage = 'Processo de carga sendo executado. Aguarde processamento.'
      ,      verrorm =  null
      where  search = 'Y';
      w_lista_jobs.extend(sql%rowcount);
      
      commit;
      
      w_cnt := 1;
      for r_db_link in c_db_link
      loop
         w_nome_job := PREFIXO_JOB||r_db_link.instance;
         dbms_scheduler.create_job (
            job_name            => w_nome_job,
            job_type            => 'PLSQL_BLOCK',
            job_action          =>  'begin'||chr(10)||
                                    'sox.verifica_disp_instancia('''||r_db_link.instance||''');'||chr(10)||
                                    'dbms_alert.signal('''||w_nome_job||''', '''||w_nome_job||''');'||chr(10)||
                                    'commit;'||chr(10)||
                                    'end;',
            number_of_arguments => 0,
            start_date          => current_date,
            enabled             => false,
            auto_drop           => true,
            comments            => 'Sarbox - Verificacao de disponibilidade da instance '||r_db_link.instance);
         w_lista_jobs(w_cnt) := w_nome_job;
         w_cnt := w_cnt + 1;
      end loop;

      execucao_jobs_paralelo(w_lista_jobs, THRESHOLD_TOTAL, THRESHOLD_PADRAO_JOB, NUM_JOBS_SIM_DEF, 'SARBOX - Disponibilidade', 'Instances', 'Instance');
      
      update sarbox_instance
      set vstatus = 'NOK'
          ,verrorm = 'Estouro da janela de execução.'
          ,vmessage = to_char(sysdate, 'dd/mm/yyyy hh24:mi:ss') || ' - Processo interrompido por estouro da janela.'
          ,verrorcount = nvl(verrorcount, 0) + 1
      where vstatus = 'WT-OK';
      
      commit;

      w_lock_status := dbms_lock.release(w_lockhandle);
      
--      w_erro_carga_vd := 0;
--      select count(1)
--      into   w_erro_carga_vd
--      from   sarbox_instance
--      where  (upper(search) = 'Y' and notify like upper(p_notify) and vstatus = 'NOK' and verrorcount < 3) or (upper(search) = 'Y' and server_instances <> server_instances_active);
--
--      if w_erro_carga_vd <> 0 then
--         /*
--         ** envio de nota de indisponibilidade
--         */
--         w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
--         utl_smtp.helo(w_mailconn, w_mailhost);
--         utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
--         if p_email is null then
--            utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
--            utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
--         else
--            utl_smtp.rcpt(w_mailconn, p_email);
--         end if;
--         utl_smtp.open_data(w_mailconn);
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Verifica ambiente'||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'AMBIENTE: Verificação de ambiente'||w_crlf));
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--
--         /*
--         ** lista instances com problemas
--         */
--         for r_coleta_erro in (select instance, verrorm, rownum from sarbox_instance where  upper(search) = 'Y' and vstatus = 'NOK' and verrorcount < 3 and notify like upper(p_notify) order by instance)
--         loop
--            if r_coleta_erro.rownum = 1 then
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentaram falhas durante o processo de verificação:'||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--            end if;
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - '||r_coleta_erro.instance||' - ERRO: '||r_coleta_erro.verrorm||w_crlf));
--         end loop;
--
--         for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(server_instances, 10)||' '||lpad(server_instances_active, 11) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and server_instances <> server_instances_active and instance <> 'ORADMVS' and notify like upper(p_notify))
--         loop
--            if r_norac.rownum = 1 then
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam indisponibilidade de nó RAC:'||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total Inst', 10)||' '||lpad('Active Inst', 11)||w_crlf));
--               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ---------- -----------'||w_crlf));
--            end if;
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
--         end loop;
--
--         utl_smtp.close_data(w_mailconn);
--         utl_smtp.quit(w_mailconn);
--      end if;

   end verifica_disponibilidade;

   procedure report_disponibilidade(p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is

      /* variaveis globlais */
      w_sql                      varchar2(4000);
      w_linha_log                varchar2(4000);
      w_commit                   number;
      w_erro_message             varchar2(400);
      w_errordt                  date;
      w_errorcount               number;
      w_erro_carga_vd            number;

   begin

      w_erro_carga_vd := 0;
      select count(1)
      into   w_erro_carga_vd
      from   sarbox_instance
      where  (upper(search) = 'Y' and notify like upper(p_notify) and vstatus = 'NOK' and verrorcount < 3) or (upper(search) = 'Y' and server_instances <> server_instances_active);

      if w_erro_carga_vd <> 0 then
         /*
         ** envio de nota de indisponibilidade
         */
         w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
         utl_smtp.helo(w_mailconn, w_mailhost);
         utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
         if p_email is null then
            utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
            utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
         else
            utl_smtp.rcpt(w_mailconn, p_email);
         end if;
         utl_smtp.open_data(w_mailconn);
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Verifica ambiente'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'AMBIENTE: Verificação de ambiente'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));

         /*
         ** lista instances com problemas
         */
         for r_coleta_erro in (select instance, verrorm, rownum from (select instance, verrorm from sarbox_instance where  upper(search) = 'Y' and vstatus = 'NOK' and verrorcount < 3 and notify like upper(p_notify) order by instance) order by rownum)
         loop
            if r_coleta_erro.rownum = 1 then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentaram falhas durante o processo de verificação:'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(' - '||r_coleta_erro.instance||' - ERRO: '||r_coleta_erro.verrorm||w_crlf));
         end loop;

         for r_norac in (select rpad(nvl(instance, ' '), 20)||' '||rpad(nvl(hostname, ' '), 20)||' '||lpad(nvl(version, ' '), 15)||' '||lpad(server_instances, 10)||' '||lpad(server_instances_active, 11) linhalog, rownum from sarbox_instance where upper(search) = 'Y' and server_instances <> server_instances_active and instance <> 'ORADMVS' and notify like upper(p_notify))
         loop
            if r_norac.rownum = 1 then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('A(s) seguinte(s) instance(s) apresentam indisponibilidade de nó RAC:'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(nvl('Instance', ' '), 20)||' '||rpad(nvl('Host Name', ' '), 20)||' '||lpad(nvl('Version', ' '), 15)||' '||lpad('Total Inst', 10)||' '||lpad('Active Inst', 11)||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- --------------- ---------- -----------'||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(r_norac.linhalog||w_crlf));
         end loop;

         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

   end report_disponibilidade;

   procedure verifica_export(p_dia in number default 1, p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is
      w_status       sarbox_instance_export.status%type;
      w_cntfull      number;
      w_cntreeng     number;
      w_cntprog      number;
      w_qtdfail      number;
      w_dtlastok     date;
      w_passou       char;
      w_msgadc       varchar2(50);
      w_linha        varchar2(255);
      w_send_mail    char := 'N';
      w_lastok       date;

      cursor c_instance is
         select instance, description, hostname
         ,      decode(platform_name, 'AIX-Based Systems (64-bit)', 'AIX',
                              'Linux IA (32-bit)', 'LNX',
                              'Linux x86 64-bit', 'LNX',
                              'Microsoft Windows IA (32-bit)', 'WIN',
                              'Microsoft Windows x86 64-bit', 'WIN',
                              'Solaris[tm] OE (64-bit)', 'SOL', '???') plat
         from   sarbox_instance
         where  upper(search) = 'Y'
         and    upper(check_pcs) = 'Y'
         and    notify like upper(p_notify)
         order  by hostname, instance;

   begin

      w_send_mail    := 'N';

      w_passou := 'N';
      for r_instance in c_instance loop
      begin
         if w_send_mail = 'N' then
            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
            utl_smtp.helo(w_mailconn, w_mailhost);
            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
            if p_email is null then
               utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
               utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
            else
               utl_smtp.rcpt(w_mailconn, p_email);
            end if;
            utl_smtp.open_data(w_mailconn);
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Relatório export'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'EXPORT: Export (full e reeng) com falhas (D-'||p_dia||')'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            w_send_mail := 'S';
         end if;

         w_cntfull   := 0;
         w_cntreeng  := 0;
         w_cntprog   := 0;

         select count(1)
         into   w_cntprog
         from   sarbox_instance_export
         where  trunc(started) >= trunc(sysdate-10)
         and    instance =  r_instance.instance;

         select max(nvl(started, to_date('01/01/01', 'dd/mm/rr')))
         into   w_lastok
         from   sarbox_instance_export
         where  status  = 'EXPFULL: Export terminated successfully without warnings.'
         and    instance =  r_instance.instance;

         select count(1)
         into   w_cntfull
         from   sarbox_instance_export
         where  exptype = 'EXPFULL'
         and    trunc(started) = trunc(sysdate-p_dia)
         and    status = 'EXPFULL: Export terminated successfully without warnings.'
         and    instance =  r_instance.instance;

         select count(1)
         into   w_cntreeng
         from   sarbox_instance_export
         where  exptype = 'EXPREENG'
         and    trunc(started) = trunc(sysdate-p_dia)
         and    status = 'EXPREENG: Export terminated successfully without warnings.'
         and    instance =  r_instance.instance;

         --dbms_output.put_line(rpad(r_instance.instance, 35)||'  '||w_cntfull||' - '||w_cntreeng||' - '||w_cntprog);

         w_msgadc := '';
         if (w_cntfull = 0) or (w_cntreeng = 0) or (w_cntprog = 0) then
            if w_passou = 'N' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad('Instance', 28)||' '||rpad('OS', 3)||' '||rpad('Export Full', 15)||' '||rpad('Export Reeng', 15)||' '||rpad('MSG Adicional (exp. full)', 50)||' '||' FC'||rpad(' Last OK', 10)||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad('----------------------------', 28)||' '||rpad('---', 3)||' '||rpad('---------------', 15)||' '||rpad('---------------', 15)||' '||rpad('--------------------------------------------------', 50)||' ---'||' --------'||w_crlf));
               w_passou := 'S';
            end if;
            w_linha := rpad(r_instance.instance|| ' ('||r_instance.hostname|| ')', 28)||' ';
            w_linha := w_linha || rpad(r_instance.plat, 3)||' ';
            w_msgadc := '';
            if w_cntprog = 0 then
               w_qtdfail := 0;
               w_linha := w_linha || rpad('Não programado', 15)||' ';
               w_linha := w_linha || rpad('Não programado', 15)||' ';
            else
               -- quantidade de falhas consecutivas
               select nvl(t2.last_ok, t1.inserted)
               into   w_dtlastok
               from
               (
               select trunc(inserted) inserted from sarbox_instance where instance = r_instance.instance
               ) t1,
               (
               select max(trunc(started)) last_ok
               from   sarbox_instance_export
               where  exptype = 'EXPFULL'
               and    status = 'EXPFULL: Export terminated successfully without warnings.'
               and    trunc(started) < trunc(sysdate-(p_dia+1))
               and    instance =  r_instance.instance
               ) t2;
               w_qtdfail := 0;
               w_qtdfail := nvl(trunc(sysdate-(p_dia+1)) - w_dtlastok, 0);
               if w_cntfull = 0 then
                  w_cntfull := 0;
                  select count(1)
                  into   w_cntfull
                  from   sarbox_instance_export
                  where  exptype = 'EXPFULL'
                  and    trunc(started) = trunc(sysdate-p_dia)
                  and    (status = 'EXPFULL: Export terminated successfully with warnings.' or status = 'EXPFULL: iniciando export.')
                  and    instance =  r_instance.instance;
                  if w_cntfull <> 0 then
                     -- terminou com warnings
                     w_cntfull := 0;
                     select count(1)
                     into   w_cntfull
                     from   sarbox_instance_export
                     where  exptype = 'EXPFULL'
                     and    trunc(started) = trunc(sysdate-p_dia)
                     and    status = 'EXPFULL: iniciando export.'
                     and    instance =  r_instance.instance;
                     if w_cntfull = 0 then
                        begin
                           select replace(substr(nvl(message_ora, message_exp), 1, 50), chr(10), chr(32))
                           into   w_msgadc
                           from   sarbox_instance_export
                           where  exptype = 'EXPFULL'
                           and    trunc(started) = trunc(sysdate-p_dia)
                           and    (status = 'EXPFULL: Export terminated successfully with warnings.')
                           and    instance =  r_instance.instance;
                        exception
                           when too_many_rows then
                              w_msgadc := 'Backup falhou mais de 1 vez (reexecutado)';
                        end;
                     else
                        -- foi iniciado e nao terminou
                        w_msgadc := 'BKP não terminou (DB caiu ou executando)';
                     end if;
                  else
                     -- nao foi iniciado
                     w_msgadc := 'BKP não foi iniciado (falha cron)';
                  end if;
                  w_linha := w_linha || rpad('Verificar', 15)||' ';
               else
                  w_linha := w_linha || rpad('ok', 15)||' ';
               end if;
               if w_cntreeng = 0 then
                  w_linha := w_linha || rpad('Verificar', 15)||' ';
               else
                  w_linha := w_linha || rpad('ok', 15)||' ';
               end if;
            end if;

            w_linha := w_linha || rpad(nvl(w_msgadc, '-'), 50)||' '||lpad(w_qtdfail, 3)||' '||to_char(w_lastok, 'DD/MM/RR');
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(w_linha||w_crlf));
         end if;
      end;
      end loop;
      if w_send_mail = 'S' then
         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

   end verifica_export;

   procedure verifica_privsoutsi(p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is
      w_instant      sarbox_instance_rolepriv.instance%type;
      w_send_mail    char := 'N';

      cursor c_abdprivs is
               select   sir.instance
               ,        sir.grantee
               ,        sir.granted_role
               ,        sir.admin_option
               ,        sir.default_role
               ,        rownum
               from     sarbox_instance_rolepriv  sir
               ,        sarbox_instance           si
               where    si.instance = sir.instance
               and      sir.granted_role not in ('DBA', 'USUARIO', 'CONNECT', 'SELECT_CATALOG_ROLE', 'ABD', 'MGMT_USER', 'OEMADMIN', 'OEMUSER', 'CPD12', 'CPD15', 'ABD_ACCENTURE')
               and      sir.grantee in (select value1 from sarbox_defs where key = 'l-abdac')
               and      sir.dropped = 'NO'
               and      si.search_privs = 'Y'
               and      si.search       = 'Y'
               and      si.notify like upper(p_notify)
               order    by sir.instance, sir.grantee, sir.granted_role;


      cursor c_afprivs is
               select siu.username
               ,      si.instance
               ,      sir.granted_role
               ,      d4pnamef
               from   sarbox_instance_rolepriv sir
               ,      d4pfuncm                 func
               ,      sarbox_instance_user     siu
               ,      sarbox_instance          si
               where  sir.grantee         = func.d4pusern
               and    sir.grantee         = siu.username
               and    sir.instance        = siu.instance
               and    siu.instance        = si.instance
               and    si.search = 'Y'
               and    siu.dropped = 'NO'
               and    sir.dropped = 'NO'
               and    granted_role not in ('USUARIO')
               and    username not in (select value1 from sarbox_defs where key = 'l-abdac')
               and    si.notify like upper(p_notify)
               order  by instance, username, granted_role;
   begin

      /*
      ** email com o privilegios da ABD
      */
      w_send_mail  := 'N';
      w_instant := '??????';
      for r_abdprivs in c_abdprivs loop
      begin
         if w_send_mail = 'N' then
            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
            utl_smtp.helo(w_mailconn, w_mailhost);
            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
            if p_email is null then
               utl_smtp.rcpt(w_mailconn, 'l-abdac@vale.com');
            else
               utl_smtp.rcpt(w_mailconn, p_email);
            end if;
            utl_smtp.open_data(w_mailconn);
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:l-abdac@vale.com'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX: Privilégios ABD'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            w_send_mail := 'S';
         end if;
         if w_instant = '??????' then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Em conformidade a regra SARBOX as permissões abaixo estão incorretas e deverão'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('ser revogadas.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('- somente as chaves da ABD estão no relatório;'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('- as possíveis roles para ABD são: DBA, CONNECT, USUARIO e SELECT_CATALOG_ROLE;'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         end if;
         if w_instant <> r_abdprivs.instance then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad('Instance', 20)||' '||rpad('User Name', 20)||' '||rpad('Role Name', 35)||' '||  rpad('Admin OPT', 10)||' '||rpad('DEF Role', 10)||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -------------------- ----------------------------------- ---------- ----------'||w_crlf));
         end if;
         w_instant := r_abdprivs.instance;
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r_abdprivs.instance, 20)||' '||rpad(r_abdprivs.grantee, 20)||' '||rpad(r_abdprivs.granted_role, 35)||' '||  rpad(r_abdprivs.admin_option, 10)||' '||rpad(r_abdprivs.default_role, 10)||w_crlf));
      end;
      end loop;
      if w_send_mail = 'S' then
         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

--      /*
--      ** email com o privilegios das AF
--      */
--      w_send_mail  := 'N';
--      w_instant := '??????';
--      for r_afprivs in c_afprivs loop
--      begin
--         if w_send_mail = 'N' then
--            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
--            utl_smtp.helo(w_mailconn, w_mailhost);
--            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
--            if p_email is null then
--               utl_smtp.rcpt(w_mailconn, 'l-abdac@vale.com');
--            else
--               utl_smtp.rcpt(w_mailconn, p_email);
--            end if;
--            utl_smtp.open_data(w_mailconn);
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:l-abdac@vale.com'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX: Privilégios Áreas Funcionais'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--            w_send_mail := 'S';
--         end if;
--         if w_instant = '??????' then
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Em conformidade a regra SARBOX as permissões abaixo estão incorretas e deverão'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('ser revogadas.'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('- somente as chaves de analistas de AF estão no relatório;'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('- a única role prevista para analista é a USUARIO, demais acessos devem ser diretos e pelo ANS Autorizador;'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('- NÃO É VERIFICADO SE O QUE ESTÁ AUTORIZADO NO BANCO É O QUE ESTÁ AUTORIZADO NO ANS Autorizador;'||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--         end if;
--         if w_instant <> r_afprivs.instance then
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad('Instance', 12)||' '||rpad('User Name', 16)||' '||rpad('Role Name', 25)||' '||  rpad('Name', 40)||w_crlf));
--            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('------------ ---------------- ------------------------- ----------------------------------------'||w_crlf));
--         end if;
--         w_instant := r_afprivs.instance;
--         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r_afprivs.instance, 12)||' '||rpad(r_afprivs.username, 16)||' '||rpad(r_afprivs.granted_role, 25)||' '||  rpad(r_afprivs.d4pnamef, 40)||w_crlf));
--      end;
--      end loop;
--      if w_send_mail = 'S' then
--         utl_smtp.close_data(w_mailconn);
--         utl_smtp.quit(w_mailconn);
--      end if;

   end verifica_privsoutsi;

   procedure   reports(p_email in varchar2 default null, p_month number default null, p_notify in varchar2 default 'Y')
   is

      w_day_last     number;
      w_day_insert   date;
      w_day_now      number;
      w_date_start   date;
      w_date_end     date;
      w_month        number;
      w_teste        boolean;
      w_typeant      number := 0;
      w_d00          varchar2(3);
      w_d01          varchar2(3);
      w_d02          varchar2(3);
      w_d03          varchar2(3);
      w_d04          varchar2(3);
      w_d05          varchar2(3);
      w_d06          varchar2(3);
      w_d07          varchar2(3);
      w_d08          varchar2(3);
      w_d09          varchar2(3);
      w_d10          varchar2(3);
      w_d11          varchar2(3);
      w_d12          varchar2(3);
      w_d13          varchar2(3);
      w_d14          varchar2(3);
      w_d15          varchar2(3);
      w_d16          varchar2(3);
      w_d17          varchar2(3);
      w_d18          varchar2(3);
      w_d19          varchar2(3);
      w_d20          varchar2(3);
      w_d21          varchar2(3);
      w_d22          varchar2(3);
      w_d23          varchar2(3);
      w_d24          varchar2(3);
      w_d25          varchar2(3);
      w_d26          varchar2(3);
      w_d27          varchar2(3);
      w_d28          varchar2(3);
      w_d29          varchar2(3);
      w_d30          varchar2(3);
      w_d31          varchar2(3);

      w_d00_f        number;
      w_d01_f        number;
      w_d02_f        number;
      w_d03_f        number;
      w_d04_f        number;
      w_d05_f        number;
      w_d06_f        number;
      w_d07_f        number;
      w_d08_f        number;
      w_d09_f        number;
      w_d10_f        number;
      w_d11_f        number;
      w_d12_f        number;
      w_d13_f        number;
      w_d14_f        number;
      w_d15_f        number;
      w_d16_f        number;
      w_d17_f        number;
      w_d18_f        number;
      w_d19_f        number;
      w_d20_f        number;
      w_d21_f        number;
      w_d22_f        number;
      w_d23_f        number;
      w_d24_f        number;
      w_d25_f        number;
      w_d26_f        number;
      w_d27_f        number;
      w_d28_f        number;
      w_d29_f        number;
      w_d30_f        number;
      w_d31_f        number;
      w_dispinst     number;

      /*
      ** horas de disponibilidade
      */
      w_disptot      number;
      w_dispint      number;
      w_indispint    number;
      w_sindispint   varchar2(10);
      w_maxdate      date;


   function valid_day(pdt_inserted in date, pdt_month_start in date, pdt_month_end in date, p_day in number)
   return boolean
   as
      w_valida    boolean;
      w_daywork   date;
      --w_teste1    varchar2(5);

   begin
      begin
         w_daywork := to_date(p_day||'/'||extract(month from pdt_month_start)||'/'||extract(year from pdt_month_start), 'dd/mm/rrrr');
         w_valida := true;
      exception
         when others then w_valida := false;
      end;

      if (w_valida = true) and (w_daywork >= pdt_inserted) then
         w_valida := true;
      else
         w_valida := false;
      end if;

      if (w_valida = true) and (w_daywork <= pdt_month_end) then
         w_valida := true;
      else
         w_valida := false;
      end if;

      if (extract(month from pdt_month_start) = extract(month from sysdate)) and (extract(year from pdt_month_start) = extract(year from sysdate)) then
         if (w_valida = true) and (w_daywork <= trunc(sysdate)-1) then
            w_valida := true;
         else
            w_valida := false;
         end if;
      end if;
      return w_valida;
   end valid_day;

   begin

      if p_month is null then
         w_month := extract(month from add_months(sysdate, -1));
      else
         w_month := p_month;
      end if;

      w_date_start := trunc(to_date('01/'||w_month||'/'||extract(year from sysdate), 'dd/mm/rrrr'));
      w_date_end   := trunc(add_months(w_date_start, 1));

      w_maxdate  := (trunc(sysdate)+(to_number(to_char(sysdate-2/24, 'hh24'))/24));
      if w_maxdate > w_date_end then
         w_maxdate := w_date_end;
      end if;


      w_disptot := (w_maxdate - w_date_start)*24*60*60;

      w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
      utl_smtp.helo(w_mailconn, w_mailhost);
      utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
      if p_email is null then
         utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
         utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
      else
         utl_smtp.rcpt(w_mailconn, p_email);
      end if;
      utl_smtp.open_data(w_mailconn);
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Mapa mensal'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'Mapa mensal de STARTUP para o mês '||substr('000'||w_month, -2)||' ('||to_char(w_date_start, 'dd/mm/rrrr')||' - '||to_char(w_date_end-1, 'dd/mm/rrrr')||')'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('LEGENDA:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ..     -> sem ocorrência de startup;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - --     -> sem informação coletada ou não é um dia válido para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - NN     -> quantidade de startup no dia;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('COLUNAS:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ID     -> para instances em RAC;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - 01..31 -> dias do mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - TT     -> total de ocorrência para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      for r1 in (select si.instance, si.type, nvl(sis.instance_id, 1) instance_id, tbo.ord,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 01 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d01,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 02 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d02,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 03 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d03,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 04 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d04,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 05 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d05,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 06 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d06,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 07 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d07,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 08 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d08,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 09 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d09,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 10 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d10,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 11 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d11,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 12 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d12,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 13 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d13,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 14 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d14,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 15 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d15,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 16 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d16,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 17 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d17,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 18 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d18,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 19 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d19,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 20 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d20,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 21 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d21,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 22 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d22,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 23 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d23,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 24 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d24,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 25 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d25,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 26 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d26,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 27 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d27,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 28 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d28,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 29 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d29,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 30 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d30,
                        sum(case when to_number(to_char(sis.startup_time, 'dd')) = 31 and (sis.startup_time >= w_date_start and sis.startup_time < w_date_end) then 1 else 0 end) d31
                 from   sarbox_instance_startup sis
                 ,      sarbox_instance         si
                 ,      (select 'P' type, 1 ord from dual union
                         select 'D' type, 3 ord from dual union
                         select 'H' type, 2 ord from dual union
                         select 'C' type, 4 ord from dual union
                         select 'T' type, 5 ord from dual union
                         select 'Q' type, 6 ord from dual union
                         select 'J' type, 6 ord from dual union
                         select 'S' type, 6 ord from dual union
                         select 'R' type, 6 ord from dual union
                         select 'U' type, 6 ord from dual union
                         select 'F' type, 6 ord from dual) tbo
                 where  si.instance      =  sis.instance(+)
                 and    si.type          = tbo.type (+)
                 and    si.search        = 'Y'
                 and    si.check_pcs     = 'Y'
                 and    si.notify like upper(p_notify)
                 group  by tbo.ord, si.type, si.instance, sis.instance_id
                 order  by tbo.ord, si.instance, sis.instance_id)
      loop
         if w_typeant <> r1.ord then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(w_crlf||'----------------------------------------------------------------------------------------------------------------------------------'||w_crlf));
            if    upper(r1.type) = 'P' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE PRODUÇÃO                                                                                                            --'||w_crlf));
            elsif upper(r1.type) = 'D' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE DESENVOLVIMENTO                                                                                                     --'||w_crlf));
            elsif upper(r1.type) = 'H' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE HOMOLOGAÇÃO                                                                                                         --'||w_crlf));
            elsif upper(r1.type) = 'C' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE CONTINGÊNCIA                                                                                                        --'||w_crlf));
            elsif upper(r1.type) = 'T' then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE TESTES                                                                                                              --'||w_crlf));
            else
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- OUTRAS BASES                                                                                                                 --'||w_crlf));
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('----------------------------------------------------------------------------------------------------------------------------------'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('INSTANCE   ID 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 TT Disp      H Indisp  '||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('---------- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --------- ----------'||w_crlf));
            w_typeant := r1.ord;
         end if;

         select   inserted
         into     w_day_insert
         from     sarbox_instance
         where    instance = r1.instance;
         w_day_last     := extract(month from add_months(sysdate, -1));
         w_day_now      := extract(day from (w_date_end-1));

         if valid_day(w_day_insert, w_date_start, w_date_end, 01) = true then if r1.d01 = 0 then w_d01 := '..'; else w_d01 := r1.d01; end if; else w_d01 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 02) = true then if r1.d02 = 0 then w_d02 := '..'; else w_d02 := r1.d02; end if; else w_d02 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 03) = true then if r1.d03 = 0 then w_d03 := '..'; else w_d03 := r1.d03; end if; else w_d03 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 04) = true then if r1.d04 = 0 then w_d04 := '..'; else w_d04 := r1.d04; end if; else w_d04 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 05) = true then if r1.d05 = 0 then w_d05 := '..'; else w_d05 := r1.d05; end if; else w_d05 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 06) = true then if r1.d06 = 0 then w_d06 := '..'; else w_d06 := r1.d06; end if; else w_d06 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 07) = true then if r1.d07 = 0 then w_d07 := '..'; else w_d07 := r1.d07; end if; else w_d07 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 08) = true then if r1.d08 = 0 then w_d08 := '..'; else w_d08 := r1.d08; end if; else w_d08 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 09) = true then if r1.d09 = 0 then w_d09 := '..'; else w_d09 := r1.d09; end if; else w_d09 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 10) = true then if r1.d10 = 0 then w_d10 := '..'; else w_d10 := r1.d10; end if; else w_d10 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 11) = true then if r1.d11 = 0 then w_d11 := '..'; else w_d11 := r1.d11; end if; else w_d11 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 12) = true then if r1.d12 = 0 then w_d12 := '..'; else w_d12 := r1.d12; end if; else w_d12 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 13) = true then if r1.d13 = 0 then w_d13 := '..'; else w_d13 := r1.d13; end if; else w_d13 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 14) = true then if r1.d14 = 0 then w_d14 := '..'; else w_d14 := r1.d14; end if; else w_d14 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 15) = true then if r1.d15 = 0 then w_d15 := '..'; else w_d15 := r1.d15; end if; else w_d15 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 16) = true then if r1.d16 = 0 then w_d16 := '..'; else w_d16 := r1.d16; end if; else w_d16 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 17) = true then if r1.d17 = 0 then w_d17 := '..'; else w_d17 := r1.d17; end if; else w_d17 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 18) = true then if r1.d18 = 0 then w_d18 := '..'; else w_d18 := r1.d18; end if; else w_d18 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 19) = true then if r1.d19 = 0 then w_d19 := '..'; else w_d19 := r1.d19; end if; else w_d19 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 20) = true then if r1.d20 = 0 then w_d20 := '..'; else w_d20 := r1.d20; end if; else w_d20 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 21) = true then if r1.d21 = 0 then w_d21 := '..'; else w_d21 := r1.d21; end if; else w_d21 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 22) = true then if r1.d22 = 0 then w_d22 := '..'; else w_d22 := r1.d22; end if; else w_d22 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 23) = true then if r1.d23 = 0 then w_d23 := '..'; else w_d23 := r1.d23; end if; else w_d23 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 24) = true then if r1.d24 = 0 then w_d24 := '..'; else w_d24 := r1.d24; end if; else w_d24 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 25) = true then if r1.d25 = 0 then w_d25 := '..'; else w_d25 := r1.d25; end if; else w_d25 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 26) = true then if r1.d26 = 0 then w_d26 := '..'; else w_d26 := r1.d26; end if; else w_d26 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 27) = true then if r1.d27 = 0 then w_d27 := '..'; else w_d27 := r1.d27; end if; else w_d27 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 28) = true then if r1.d28 = 0 then w_d28 := '..'; else w_d28 := r1.d28; end if; else w_d28 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 29) = true then if r1.d29 = 0 then w_d29 := '..'; else w_d29 := r1.d29; end if; else w_d29 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 30) = true then if r1.d30 = 0 then w_d30 := '..'; else w_d30 := r1.d30; end if; else w_d30 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 31) = true then if r1.d31 = 0 then w_d31 := '..'; else w_d31 := r1.d31; end if; else w_d31 := '--'; end if;

         w_dispinst := apura_disponibilidade(r1.instance, r1.instance_id, w_month);

         w_dispint      := w_disptot * (w_dispinst/100);
         w_indispint    := w_disptot * ((100-w_dispinst)/100);
         select lpad(trim(to_char(floor((w_indispint)/(3600)), 9990))||':'|| trim(to_char(floor((((w_indispint)) - (floor(((w_indispint))/(3600))*3600))/60), 900))||':'||trim(to_char(mod((((w_indispint)) - (floor(((w_indispint))/(3600))*3600)),60), 900)), 10, ' ')
         into   w_sindispint
         from   dual;

         --dbms_output.put_line(rpad(r1.instance, 12)||' - '||w_sindispint);

         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r1.instance, 10)||' '||
                              lpad(r1.instance_id, 2)||' '||
                              lpad(w_d01, 2)||' '||
                              lpad(w_d02, 2)||' '||
                              lpad(w_d03, 2)||' '||
                              lpad(w_d04, 2)||' '||
                              lpad(w_d05, 2)||' '||
                              lpad(w_d06, 2)||' '||
                              lpad(w_d07, 2)||' '||
                              lpad(w_d08, 2)||' '||
                              lpad(w_d09, 2)||' '||
                              lpad(w_d10, 2)||' '||
                              lpad(w_d11, 2)||' '||
                              lpad(w_d12, 2)||' '||
                              lpad(w_d13, 2)||' '||
                              lpad(w_d14, 2)||' '||
                              lpad(w_d15, 2)||' '||
                              lpad(w_d16, 2)||' '||
                              lpad(w_d17, 2)||' '||
                              lpad(w_d18, 2)||' '||
                              lpad(w_d19, 2)||' '||
                              lpad(w_d20, 2)||' '||
                              lpad(w_d21, 2)||' '||
                              lpad(w_d22, 2)||' '||
                              lpad(w_d23, 2)||' '||
                              lpad(w_d24, 2)||' '||
                              lpad(w_d25, 2)||' '||
                              lpad(w_d26, 2)||' '||
                              lpad(w_d27, 2)||' '||
                              lpad(w_d28, 2)||' '||
                              lpad(w_d29, 2)||' '||
                              lpad(w_d30, 2)||' '||
                              lpad(w_d31, 2)||' '||
                              lpad(r1.d01+r1.d02+r1.d03+r1.d04+r1.d05+r1.d06+r1.d07+r1.d08+r1.d09+r1.d10+r1.d11+r1.d12+r1.d13+r1.d14+r1.d15+r1.d16+r1.d17+r1.d18+r1.d19+r1.d20+r1.d21+r1.d22+r1.d23+r1.d24+r1.d25+r1.d26+r1.d27+r1.d28+r1.d29+r1.d30+r1.d31, 2)||' '||
                              lpad(trim(to_char(w_dispinst, '999.99999')), 9) ||' '||
                              lpad(trim(w_sindispint), 10)||w_crlf));

      end loop;
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
      utl_smtp.close_data(w_mailconn);
      utl_smtp.quit(w_mailconn);

      w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
      utl_smtp.helo(w_mailconn, w_mailhost);
      utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
      if p_email is null then
         utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
         utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
      else
         utl_smtp.rcpt(w_mailconn, p_email);
      end if;

      utl_smtp.open_data(w_mailconn);
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Mapa mensal'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'Mapa mensal de EXPORT FULL para o mês '||substr('000'||w_month, -2)||' ('||to_char(w_date_start, 'dd/mm/rrrr')||' - '||to_char(w_date_end-1, 'dd/mm/rrrr')||')'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('LEGENDA:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ..     -> sem ocorrência de export;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - --     -> sem informação coletada ou não é um dia válido para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ER     -> ocorrência de erro para o dia;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('COLUNAS:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - 01..31 -> dias do mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - TT     -> total de ocorrência para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      for r1 in (select si.instance, si.type, tbo.ord,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 01 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d01,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 02 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d02,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 03 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d03,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 04 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d04,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 05 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d05,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 06 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d06,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 07 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d07,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 08 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d08,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 09 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d09,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 10 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d10,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 11 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d11,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 12 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d12,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 13 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d13,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 14 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d14,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 15 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d15,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 16 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d16,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 17 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d17,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 18 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d18,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 19 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d19,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 20 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d20,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 21 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d21,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 22 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d22,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 23 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d23,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 24 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d24,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 25 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d25,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 26 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d26,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 27 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d27,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 28 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d28,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 29 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d29,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 30 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d30,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 31 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPFULL' and sie. status = 'EXPFULL: Export terminated successfully without warnings.') then 1 else 0 end) d31
                 from   sarbox_instance_export sie
                 ,      sarbox_instance         si
                 ,      (select 'P' type, 1 ord from dual union
                         select 'D' type, 3 ord from dual union
                         select 'H' type, 2 ord from dual union
                         select 'C' type, 4 ord from dual union
                         select 'T' type, 5 ord from dual union
                         select 'Q' type, 6 ord from dual union
                         select 'J' type, 6 ord from dual union
                         select 'S' type, 6 ord from dual union
                         select 'R' type, 6 ord from dual union
                         select 'U' type, 6 ord from dual union
                         select 'F' type, 6 ord from dual) tbo
                 where  si.instance      =  sie.instance(+)
                 and    si.type          = tbo.type (+)
                 and    si.search        = 'Y'
                 and    si.check_pcs     = 'Y'
                 and    si.notify        like upper(p_notify)
                 group  by tbo.ord, si.type, si.instance
                 order  by tbo.ord, si.instance)
      loop

         select   inserted
         into     w_day_insert
         from     sarbox_instance
         where    instance = r1.instance;
         w_day_last     := extract(month from add_months(sysdate, -1));
         w_day_now      := extract(day from (w_date_end-1));

         w_d01_f := 0;
         w_d02_f := 0;
         w_d03_f := 0;
         w_d04_f := 0;
         w_d05_f := 0;
         w_d06_f := 0;
         w_d07_f := 0;
         w_d08_f := 0;
         w_d09_f := 0;
         w_d10_f := 0;
         w_d11_f := 0;
         w_d12_f := 0;
         w_d13_f := 0;
         w_d14_f := 0;
         w_d15_f := 0;
         w_d16_f := 0;
         w_d17_f := 0;
         w_d18_f := 0;
         w_d19_f := 0;
         w_d20_f := 0;
         w_d21_f := 0;
         w_d22_f := 0;
         w_d23_f := 0;
         w_d24_f := 0;
         w_d25_f := 0;
         w_d26_f := 0;
         w_d27_f := 0;
         w_d28_f := 0;
         w_d29_f := 0;
         w_d30_f := 0;
         w_d31_f := 0;
         w_d00_f := 0;

         if valid_day(w_day_insert, w_date_start, w_date_end, 01) = true then if r1.d01 > 0 then w_d01 := '..'; else w_d01 := 'ER'; w_d01_f := 1; end if; else w_d01 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 02) = true then if r1.d02 > 0 then w_d02 := '..'; else w_d02 := 'ER'; w_d02_f := 1; end if; else w_d02 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 03) = true then if r1.d03 > 0 then w_d03 := '..'; else w_d03 := 'ER'; w_d03_f := 1; end if; else w_d03 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 04) = true then if r1.d04 > 0 then w_d04 := '..'; else w_d04 := 'ER'; w_d04_f := 1; end if; else w_d04 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 05) = true then if r1.d05 > 0 then w_d05 := '..'; else w_d05 := 'ER'; w_d05_f := 1; end if; else w_d05 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 06) = true then if r1.d06 > 0 then w_d06 := '..'; else w_d06 := 'ER'; w_d06_f := 1; end if; else w_d06 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 07) = true then if r1.d07 > 0 then w_d07 := '..'; else w_d07 := 'ER'; w_d07_f := 1; end if; else w_d07 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 08) = true then if r1.d08 > 0 then w_d08 := '..'; else w_d08 := 'ER'; w_d08_f := 1; end if; else w_d08 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 09) = true then if r1.d09 > 0 then w_d09 := '..'; else w_d09 := 'ER'; w_d09_f := 1; end if; else w_d09 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 10) = true then if r1.d10 > 0 then w_d10 := '..'; else w_d10 := 'ER'; w_d10_f := 1; end if; else w_d10 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 11) = true then if r1.d11 > 0 then w_d11 := '..'; else w_d11 := 'ER'; w_d11_f := 1; end if; else w_d11 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 12) = true then if r1.d12 > 0 then w_d12 := '..'; else w_d12 := 'ER'; w_d12_f := 1; end if; else w_d12 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 13) = true then if r1.d13 > 0 then w_d13 := '..'; else w_d13 := 'ER'; w_d13_f := 1; end if; else w_d13 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 14) = true then if r1.d14 > 0 then w_d14 := '..'; else w_d14 := 'ER'; w_d14_f := 1; end if; else w_d14 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 15) = true then if r1.d15 > 0 then w_d15 := '..'; else w_d15 := 'ER'; w_d15_f := 1; end if; else w_d15 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 16) = true then if r1.d16 > 0 then w_d16 := '..'; else w_d16 := 'ER'; w_d16_f := 1; end if; else w_d16 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 17) = true then if r1.d17 > 0 then w_d17 := '..'; else w_d17 := 'ER'; w_d17_f := 1; end if; else w_d17 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 18) = true then if r1.d18 > 0 then w_d18 := '..'; else w_d18 := 'ER'; w_d18_f := 1; end if; else w_d18 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 19) = true then if r1.d19 > 0 then w_d19 := '..'; else w_d19 := 'ER'; w_d19_f := 1; end if; else w_d19 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 20) = true then if r1.d20 > 0 then w_d20 := '..'; else w_d20 := 'ER'; w_d20_f := 1; end if; else w_d20 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 21) = true then if r1.d21 > 0 then w_d21 := '..'; else w_d21 := 'ER'; w_d21_f := 1; end if; else w_d21 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 22) = true then if r1.d22 > 0 then w_d22 := '..'; else w_d22 := 'ER'; w_d22_f := 1; end if; else w_d22 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 23) = true then if r1.d23 > 0 then w_d23 := '..'; else w_d23 := 'ER'; w_d23_f := 1; end if; else w_d23 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 24) = true then if r1.d24 > 0 then w_d24 := '..'; else w_d24 := 'ER'; w_d24_f := 1; end if; else w_d24 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 25) = true then if r1.d25 > 0 then w_d25 := '..'; else w_d25 := 'ER'; w_d25_f := 1; end if; else w_d25 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 26) = true then if r1.d26 > 0 then w_d26 := '..'; else w_d26 := 'ER'; w_d26_f := 1; end if; else w_d26 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 27) = true then if r1.d27 > 0 then w_d27 := '..'; else w_d27 := 'ER'; w_d27_f := 1; end if; else w_d27 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 28) = true then if r1.d28 > 0 then w_d28 := '..'; else w_d28 := 'ER'; w_d28_f := 1; end if; else w_d28 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 29) = true then if r1.d29 > 0 then w_d29 := '..'; else w_d29 := 'ER'; w_d29_f := 1; end if; else w_d29 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 30) = true then if r1.d30 > 0 then w_d30 := '..'; else w_d30 := 'ER'; w_d30_f := 1; end if; else w_d30 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 31) = true then if r1.d31 > 0 then w_d31 := '..'; else w_d31 := 'ER'; w_d31_f := 1; end if; else w_d31 := '--'; end if;

         w_d00_f := w_d01_f+w_d02_f+w_d03_f+w_d04_f+w_d05_f+w_d06_f+w_d07_f+w_d08_f+w_d09_f+w_d10_f+w_d11_f+w_d12_f+w_d13_f+w_d14_f+w_d15_f+w_d16_f+w_d17_f+w_d18_f+w_d19_f+w_d20_f+w_d21_f+w_d22_f+w_d23_f+w_d24_f+w_d25_f+w_d26_f+w_d27_f+w_d28_f+w_d29_f+w_d30_f+w_d31_f;

         if w_d00_f = 0 then w_d00 := '..'; else w_d00 := w_d00_f; end if;

         --if w_d00_f <> 0 then

            if w_typeant <> r1.ord then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(w_crlf||'--------------------------------------------------------------------------------------------------------------------'||w_crlf));
               if    upper(r1.type) = 'P' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE PRODUÇÃO                                                                                              --'||w_crlf));
               elsif upper(r1.type) = 'D' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE DESENVOLVIMENTO                                                                                       --'||w_crlf));
               elsif upper(r1.type) = 'H' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE HOMOLOGAÇÃO                                                                                           --'||w_crlf));
               elsif upper(r1.type) = 'C' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE CONTINGÊNCIA                                                                                          --'||w_crlf));
               elsif upper(r1.type) = 'T' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE TESTES                                                                                                --'||w_crlf));
               else
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- OUTRAS BASES                                                                                                   --'||w_crlf));
               end if;
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('--------------------------------------------------------------------------------------------------------------------'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('INSTANCE             01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 TT'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --'||w_crlf));
               w_typeant := r1.ord;
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r1.instance, 20)||' '||
                                 lpad(w_d01, 2)||' '||
                                 lpad(w_d02, 2)||' '||
                                 lpad(w_d03, 2)||' '||
                                 lpad(w_d04, 2)||' '||
                                 lpad(w_d05, 2)||' '||
                                 lpad(w_d06, 2)||' '||
                                 lpad(w_d07, 2)||' '||
                                 lpad(w_d08, 2)||' '||
                                 lpad(w_d09, 2)||' '||
                                 lpad(w_d10, 2)||' '||
                                 lpad(w_d11, 2)||' '||
                                 lpad(w_d12, 2)||' '||
                                 lpad(w_d13, 2)||' '||
                                 lpad(w_d14, 2)||' '||
                                 lpad(w_d15, 2)||' '||
                                 lpad(w_d16, 2)||' '||
                                 lpad(w_d17, 2)||' '||
                                 lpad(w_d18, 2)||' '||
                                 lpad(w_d19, 2)||' '||
                                 lpad(w_d20, 2)||' '||
                                 lpad(w_d21, 2)||' '||
                                 lpad(w_d22, 2)||' '||
                                 lpad(w_d23, 2)||' '||
                                 lpad(w_d24, 2)||' '||
                                 lpad(w_d25, 2)||' '||
                                 lpad(w_d26, 2)||' '||
                                 lpad(w_d27, 2)||' '||
                                 lpad(w_d28, 2)||' '||
                                 lpad(w_d29, 2)||' '||
                                 lpad(w_d30, 2)||' '||
                                 lpad(w_d31, 2)||' '||
                                 lpad(w_d00, 2)||w_crlf));
         --end if;
      end loop;
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
      utl_smtp.close_data(w_mailconn);
      utl_smtp.quit(w_mailconn);

      w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
      utl_smtp.helo(w_mailconn, w_mailhost);
      utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
      if p_email is null then
         utl_smtp.rcpt(w_mailconn, 'abd-adm@vale.com');
         utl_smtp.rcpt(w_mailconn, 'c0095265@vale.com');
      else
         utl_smtp.rcpt(w_mailconn, p_email);
      end if;
      utl_smtp.open_data(w_mailconn);
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:OPERACAO - Mapa mensal'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:abd-adm@vale.com'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'Mapa mensal de EXPORT REENG para o mês '||substr('000'||w_month, -2)||' ('||to_char(w_date_start, 'dd/mm/rrrr')||' - '||to_char(w_date_end-1, 'dd/mm/rrrr')||')'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('LEGENDA:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ..     -> sem ocorrência de export;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - --     -> sem informação coletada ou não é um dia válido para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - ER     -> ocorrência de erro para o dia;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('COLUNAS:'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - 01..31 -> dias do mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('  - TT     -> total de ocorrência para o mês;'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      for r1 in (select si.instance, si.type, tbo.ord,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 01 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d01,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 02 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d02,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 03 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d03,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 04 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d04,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 05 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d05,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 06 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d06,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 07 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d07,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 08 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d08,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 09 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d09,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 10 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d10,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 11 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d11,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 12 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d12,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 13 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d13,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 14 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d14,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 15 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d15,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 16 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d16,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 17 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d17,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 18 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d18,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 19 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d19,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 20 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d20,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 21 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d21,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 22 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d22,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 23 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d23,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 24 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d24,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 25 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d25,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 26 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d26,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 27 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d27,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 28 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d28,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 29 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d29,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 30 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d30,
                        sum(case when to_number(to_char(sie.started, 'dd')) = 31 and (sie.started >= w_date_start and sie.started < w_date_end and sie.exptype = 'EXPREENG' and sie. status = 'EXPREENG: Export terminated successfully without warnings.') then 1 else 0 end) d31
                 from   sarbox_instance_export sie
                 ,      sarbox_instance         si
                 ,      (select 'P' type, 1 ord from dual union
                         select 'D' type, 3 ord from dual union
                         select 'H' type, 2 ord from dual union
                         select 'C' type, 4 ord from dual union
                         select 'T' type, 5 ord from dual union
                         select 'Q' type, 6 ord from dual union
                         select 'J' type, 6 ord from dual union
                         select 'S' type, 6 ord from dual union
                         select 'R' type, 6 ord from dual union
                         select 'U' type, 6 ord from dual union
                         select 'F' type, 6 ord from dual) tbo
                 where  si.instance      =  sie.instance(+)
                 and    si.type          = tbo.type(+)
                 and    si.search        = 'Y'
                 and    si.check_pcs     = 'Y'
                 and    si.notify        like upper(p_notify)
                 group  by tbo.ord, si.type, si.instance
                 order  by tbo.ord, si.instance)
      loop

         select   inserted
         into     w_day_insert
         from     sarbox_instance
         where    instance = r1.instance;
         w_day_last     := extract(month from add_months(sysdate, -1));
         w_day_now      := extract(day from (w_date_end-1));

         w_d01_f := 0;
         w_d02_f := 0;
         w_d03_f := 0;
         w_d04_f := 0;
         w_d05_f := 0;
         w_d06_f := 0;
         w_d07_f := 0;
         w_d08_f := 0;
         w_d09_f := 0;
         w_d10_f := 0;
         w_d11_f := 0;
         w_d12_f := 0;
         w_d13_f := 0;
         w_d14_f := 0;
         w_d15_f := 0;
         w_d16_f := 0;
         w_d17_f := 0;
         w_d18_f := 0;
         w_d19_f := 0;
         w_d20_f := 0;
         w_d21_f := 0;
         w_d22_f := 0;
         w_d23_f := 0;
         w_d24_f := 0;
         w_d25_f := 0;
         w_d26_f := 0;
         w_d27_f := 0;
         w_d28_f := 0;
         w_d29_f := 0;
         w_d30_f := 0;
         w_d31_f := 0;
         w_d00_f := 0;

         if valid_day(w_day_insert, w_date_start, w_date_end, 01) = true then if r1.d01 > 0 then w_d01 := '..'; else w_d01 := 'ER'; w_d01_f := 1; end if; else w_d01 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 02) = true then if r1.d02 > 0 then w_d02 := '..'; else w_d02 := 'ER'; w_d02_f := 1; end if; else w_d02 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 03) = true then if r1.d03 > 0 then w_d03 := '..'; else w_d03 := 'ER'; w_d03_f := 1; end if; else w_d03 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 04) = true then if r1.d04 > 0 then w_d04 := '..'; else w_d04 := 'ER'; w_d04_f := 1; end if; else w_d04 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 05) = true then if r1.d05 > 0 then w_d05 := '..'; else w_d05 := 'ER'; w_d05_f := 1; end if; else w_d05 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 06) = true then if r1.d06 > 0 then w_d06 := '..'; else w_d06 := 'ER'; w_d06_f := 1; end if; else w_d06 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 07) = true then if r1.d07 > 0 then w_d07 := '..'; else w_d07 := 'ER'; w_d07_f := 1; end if; else w_d07 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 08) = true then if r1.d08 > 0 then w_d08 := '..'; else w_d08 := 'ER'; w_d08_f := 1; end if; else w_d08 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 09) = true then if r1.d09 > 0 then w_d09 := '..'; else w_d09 := 'ER'; w_d09_f := 1; end if; else w_d09 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 10) = true then if r1.d10 > 0 then w_d10 := '..'; else w_d10 := 'ER'; w_d10_f := 1; end if; else w_d10 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 11) = true then if r1.d11 > 0 then w_d11 := '..'; else w_d11 := 'ER'; w_d11_f := 1; end if; else w_d11 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 12) = true then if r1.d12 > 0 then w_d12 := '..'; else w_d12 := 'ER'; w_d12_f := 1; end if; else w_d12 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 13) = true then if r1.d13 > 0 then w_d13 := '..'; else w_d13 := 'ER'; w_d13_f := 1; end if; else w_d13 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 14) = true then if r1.d14 > 0 then w_d14 := '..'; else w_d14 := 'ER'; w_d14_f := 1; end if; else w_d14 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 15) = true then if r1.d15 > 0 then w_d15 := '..'; else w_d15 := 'ER'; w_d15_f := 1; end if; else w_d15 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 16) = true then if r1.d16 > 0 then w_d16 := '..'; else w_d16 := 'ER'; w_d16_f := 1; end if; else w_d16 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 17) = true then if r1.d17 > 0 then w_d17 := '..'; else w_d17 := 'ER'; w_d17_f := 1; end if; else w_d17 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 18) = true then if r1.d18 > 0 then w_d18 := '..'; else w_d18 := 'ER'; w_d18_f := 1; end if; else w_d18 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 19) = true then if r1.d19 > 0 then w_d19 := '..'; else w_d19 := 'ER'; w_d19_f := 1; end if; else w_d19 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 20) = true then if r1.d20 > 0 then w_d20 := '..'; else w_d20 := 'ER'; w_d20_f := 1; end if; else w_d20 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 21) = true then if r1.d21 > 0 then w_d21 := '..'; else w_d21 := 'ER'; w_d21_f := 1; end if; else w_d21 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 22) = true then if r1.d22 > 0 then w_d22 := '..'; else w_d22 := 'ER'; w_d22_f := 1; end if; else w_d22 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 23) = true then if r1.d23 > 0 then w_d23 := '..'; else w_d23 := 'ER'; w_d23_f := 1; end if; else w_d23 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 24) = true then if r1.d24 > 0 then w_d24 := '..'; else w_d24 := 'ER'; w_d24_f := 1; end if; else w_d24 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 25) = true then if r1.d25 > 0 then w_d25 := '..'; else w_d25 := 'ER'; w_d25_f := 1; end if; else w_d25 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 26) = true then if r1.d26 > 0 then w_d26 := '..'; else w_d26 := 'ER'; w_d26_f := 1; end if; else w_d26 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 27) = true then if r1.d27 > 0 then w_d27 := '..'; else w_d27 := 'ER'; w_d27_f := 1; end if; else w_d27 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 28) = true then if r1.d28 > 0 then w_d28 := '..'; else w_d28 := 'ER'; w_d28_f := 1; end if; else w_d28 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 29) = true then if r1.d29 > 0 then w_d29 := '..'; else w_d29 := 'ER'; w_d29_f := 1; end if; else w_d29 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 30) = true then if r1.d30 > 0 then w_d30 := '..'; else w_d30 := 'ER'; w_d30_f := 1; end if; else w_d30 := '--'; end if;
         if valid_day(w_day_insert, w_date_start, w_date_end, 31) = true then if r1.d31 > 0 then w_d31 := '..'; else w_d31 := 'ER'; w_d31_f := 1; end if; else w_d31 := '--'; end if;

         w_d00_f := w_d01_f+w_d02_f+w_d03_f+w_d04_f+w_d05_f+w_d06_f+w_d07_f+w_d08_f+w_d09_f+w_d10_f+w_d11_f+w_d12_f+w_d13_f+w_d14_f+w_d15_f+w_d16_f+w_d17_f+w_d18_f+w_d19_f+w_d20_f+w_d21_f+w_d22_f+w_d23_f+w_d24_f+w_d25_f+w_d26_f+w_d27_f+w_d28_f+w_d29_f+w_d30_f+w_d31_f;

         if w_d00_f = 0 then w_d00 := '..'; else w_d00 := w_d00_f; end if;

         --if w_d00_f <> 0 then

            if w_typeant <> r1.ord then
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(w_crlf||'--------------------------------------------------------------------------------------------------------------------'||w_crlf));
               if    upper(r1.type) = 'P' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE PRODUÇÃO                                                                                              --'||w_crlf));
               elsif upper(r1.type) = 'D' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE DESENVOLVIMENTO                                                                                       --'||w_crlf));
               elsif upper(r1.type) = 'H' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE HOMOLOGAÇÃO                                                                                           --'||w_crlf));
               elsif upper(r1.type) = 'C' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE CONTINGÊNCIA                                                                                          --'||w_crlf));
               elsif upper(r1.type) = 'T' then
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- BASES DE TESTES                                                                                                --'||w_crlf));
               else
                  utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-- OUTRAS BASES                                                                                                   --'||w_crlf));
               end if;
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('--------------------------------------------------------------------------------------------------------------------'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('INSTANCE             01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 TT'||w_crlf));
               utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --'||w_crlf));
               w_typeant := r1.ord;
            end if;
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r1.instance, 20)||' '||
                                 lpad(w_d01, 2)||' '||
                                 lpad(w_d02, 2)||' '||
                                 lpad(w_d03, 2)||' '||
                                 lpad(w_d04, 2)||' '||
                                 lpad(w_d05, 2)||' '||
                                 lpad(w_d06, 2)||' '||
                                 lpad(w_d07, 2)||' '||
                                 lpad(w_d08, 2)||' '||
                                 lpad(w_d09, 2)||' '||
                                 lpad(w_d10, 2)||' '||
                                 lpad(w_d11, 2)||' '||
                                 lpad(w_d12, 2)||' '||
                                 lpad(w_d13, 2)||' '||
                                 lpad(w_d14, 2)||' '||
                                 lpad(w_d15, 2)||' '||
                                 lpad(w_d16, 2)||' '||
                                 lpad(w_d17, 2)||' '||
                                 lpad(w_d18, 2)||' '||
                                 lpad(w_d19, 2)||' '||
                                 lpad(w_d20, 2)||' '||
                                 lpad(w_d21, 2)||' '||
                                 lpad(w_d22, 2)||' '||
                                 lpad(w_d23, 2)||' '||
                                 lpad(w_d24, 2)||' '||
                                 lpad(w_d25, 2)||' '||
                                 lpad(w_d26, 2)||' '||
                                 lpad(w_d27, 2)||' '||
                                 lpad(w_d28, 2)||' '||
                                 lpad(w_d29, 2)||' '||
                                 lpad(w_d30, 2)||' '||
                                 lpad(w_d31, 2)||' '||
                                 lpad(w_d00, 2)||w_crlf));

         --end if;
      end loop;
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
      utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
      utl_smtp.close_data(w_mailconn);
      utl_smtp.quit(w_mailconn);

   end reports;

   procedure verifica_node(p_email in varchar2 default null, p_notify in varchar2 default 'Y')
   is
      w_instant      sarbox_instance_rolepriv.instance%type;
      w_send_mail    char := 'N';
      cursor c_node is
               select instance
               ,      version
               ,      hostname
               ,      preferred_node
               ,      to_char(startup_time, 'dd/mm/rrrr hh24:mi:ss') st
               from   sarbox_instance
               where  server_instances = 1
               and    nvl(hostname, '????') <> preferred_node
               and    search = 'Y'
               and    notify like upper(p_notify);


   begin

      w_send_mail  := 'N';

      w_instant := '??????';

      for r_node in c_node loop
      begin
         if w_send_mail = 'N' then
            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
            utl_smtp.helo(w_mailconn, w_mailhost);
            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
            if p_email is null then
               utl_smtp.rcpt(w_mailconn, 'l-abdac@vale.com');
            else
               utl_smtp.rcpt(w_mailconn, p_email);
            end if;
            utl_smtp.open_data(w_mailconn);
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:l-abdac@vale.com'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX: Instances fora do nó preferencial'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            w_send_mail := 'S';
         end if;

         if w_instant = '??????' then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('As seguintes instances estão disponíveis fora do nó preferencial.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad('Instance', 20)||' '||lpad('Version', 15)||' '||rpad('Nó Atual', 20)||' '||  rpad('Nó Preferencial', 20)||' '||rpad('Startup', 19)||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('-------------------- --------------- -------------------- -------------------- -------------------'||w_crlf));
         end if;
         w_instant := r_node.instance;
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(rpad(r_node.instance, 20)||' '||lpad(r_node.version, 15)||' '||rpad(r_node.hostname, 20)||' '||  rpad(r_node.preferred_node, 20)||' '||rpad(r_node.st, 19)||w_crlf));
      end;
      end loop;
      if w_send_mail = 'S' then
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

   end verifica_node;

   procedure auto_verificacao(p_email in varchar2 default null)
   is
      w_instant      sarbox_instance_rolepriv.instance%type;
      w_send_mail    char := 'N';
      cursor c_verifica is
             select s.sid
             ,      dj.job
             ,      s.seconds_in_wait
             ,      trim(replace(replace(replace(lower(dj.what), 'begin ', ''), 'end;', ''), 'pak_sox00001.', '')) what
             ,      trim(replace(replace(replace(s.client_info, 'SARBOX - ', ''), 'Disponibilidade ', 'D '), 'Coleta ', 'C ')) info
             ,      rownum
             from   v$session         s
             ,      dba_jobs          dj
             ,      dba_jobs_running  djr
             where  s.sid = djr.sid
             and    dj.job   = djr.job
             and    seconds_in_wait >= 900
             and    schema_user = 'PCSOX';

   begin

      w_send_mail  := 'N';

      w_instant := '??????';

      for r_verifica in c_verifica loop
      begin
         if w_send_mail = 'N' then
            w_mailconn := utl_smtp.open_connection(w_mailhost, 25);
            utl_smtp.helo(w_mailconn, w_mailhost);
            utl_smtp.mail(w_mailconn, 'abd-adm@vale.com');
            if p_email is null then
               utl_smtp.rcpt(w_mailconn, 'l-abdac@vale.com');
            else
               utl_smtp.rcpt(w_mailconn, p_email);
            end if;
            utl_smtp.open_data(w_mailconn);
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Date:'||to_char(sysdate,'dd-mon-yyyy hh24:mi:ss')||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('From:SARBOX'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('To:l-abdac@vale.com'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Subject:'||'SARBOX: Auto verificação'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            w_send_mail := 'S';
         end if;

         if r_verifica.rownum = 1 then
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Os seguintes jobs SARBOX apresentam algum problema. Favor verificar.'||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(lpad('SID', 7)||' '||lpad('JOB', 7)||' '||lpad('Wait S', 7)||' '||  rpad('INFO', 25)||' '||rpad('WHAT', 55)||w_crlf));
            utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('------- ------- ------- ------------------------- -------------------------------------------------------'||w_crlf));
         end if;

         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(lpad(r_verifica.sid, 7)||' '||lpad(r_verifica.job, 7)||' '||lpad(r_verifica.seconds_in_wait, 7)||' '||rpad(r_verifica.info, 25)||' '||rpad(r_verifica.what, 55)||w_crlf));
      end;
      end loop;
      if w_send_mail = 'S' then
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw(''||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Obs.: Mensagem automática, favor não responder.'||w_crlf));
         utl_smtp.write_raw_data(w_mailconn, utl_raw.cast_to_raw('Administração de Banco de Dados / Accenture'||w_crlf));
         utl_smtp.close_data(w_mailconn);
         utl_smtp.quit(w_mailconn);
      end if;

   end auto_verificacao;

   procedure getinfo_oem
   as

      w_instance_oem varchar2(16);
      w_instacce_con varchar2(200);
      w_instance_dbl varchar2(200);
      w_sql          varchar2(1500);
      w_commit       number;
      w_datetimeproc date;

      type rc is ref cursor;
      c_fs        rc;

      /*
      ** variaveis para o cursor
      */
      w_fs_host      sarbox_instance_fs.hostname%type;
      w_fs_fs        sarbox_instance_fs.filesystem%type;
      w_fs_mp        sarbox_instance_fs.mountpoint%type;
      w_fs_sizeb     sarbox_instance_fs.sizeb%type;
      w_fs_usedb     sarbox_instance_fs.usedb%type;
      w_fs_freeb     sarbox_instance_fs.freeb%type;
      w_fs_pct       sarbox_instance_fs.pctuse%type;

   begin

      w_datetimeproc := sysdate;

      w_instance_oem := 'ORAPVT041';
      select connect_string
      into   w_instacce_con
      from   sarbox_instance
      where  instance = w_instance_oem;

      w_instance_dbl := 'ORAPVT041_OEM';

      begin
         w_sql := 'create database link '||w_instance_dbl||' '||pak_sox00001.ctv(w_ws)||' using '||chr(39)||w_instacce_con||chr(39);
         execute immediate (w_sql);
      exception
         when others then null;
      end;


      for r_fs_ex in (select rowid from sarbox_instance_fs where dropped <> 'YES')
      loop
         update sarbox_instance_fs
         set    dropped   = 'YES'
         ,      dtdropped = w_datetimeproc
         where rowid = r_fs_ex.rowid;
      end loop;
      commit;

      begin
         w_sql := 'select target_name host, filesystem fs, mountpoint mp, sizeb sizeb, usedb usedb, freeb freeb, trunc((usedb/sizeb)*100) pct from sysman.mgmt$storage_report_localfs@'||w_instance_dbl||' where upper(mountpoint) like upper('||chr(39)||'%oradata%'||chr(39)||') or upper(mountpoint) like upper('||chr(39)||'%software%'||chr(39)||') or upper(mountpoint) like upper('||chr(39)||'%bkpcvrd%'||chr(39)||') or upper(mountpoint) like upper('||chr(39)||'%transfer%'||chr(39)||') order by host';
         w_commit:= 0;
         open c_fs for w_sql;
         loop
            fetch c_fs into w_fs_host, w_fs_fs, w_fs_mp, w_fs_sizeb, w_fs_usedb, w_fs_freeb, w_fs_pct;
            exit when c_fs%notfound;
            if w_commit = 500 then
               commit;
               w_commit := 0;
            end if;
            w_commit := w_commit + 1;
            update sarbox_instance_fs
            set    sizeb         = w_fs_sizeb
            ,      usedb         = w_fs_usedb
            ,      freeb         = w_fs_freeb
            ,      pctuse        = w_fs_pct
            ,      dropped       = 'NO'
            ,      dtdropped     = null
            where  hostname      = w_fs_host
            and    filesystem    = w_fs_fs;

            if sql%rowcount = 0 then -- registros afetados na ultima instrucao SQL. 0 (zero) não fez update em nenhum registro.
               insert
                  into sarbox_instance_fs

                     ( hostname,       filesystem,       mountpoint,       sizeb,         usedb,
                       freeb,          pctuse,           dtinsert,         dtdropped,     dropped
                     )
                  values
                     ( w_fs_host,      w_fs_fs,          w_fs_mp,          w_fs_sizeb,    w_fs_usedb
                     , w_fs_freeb,     w_fs_pct,         sysdate,          null,          'NO'
                     );
            end if;
         end loop;
         commit;
         close c_fs;
      exception
         when dup_val_on_index then null;
         when others then
            if sqlcode = -942 then
               null;
            end if;
      end;
      commit;

      begin
         w_sql := 'ALTER SESSION CLOSE DATABASE LINK '||w_instance_dbl;
         execute immediate (w_sql);
         w_sql := 'drop database link '||w_instance_dbl;
         execute immediate (w_sql);
      exception
         when others then
            if sqlcode = -2081 then
               w_sql := 'DROP DATABASE LINK '||w_instance_dbl;
               execute immediate (w_sql);
            else
               null;
            end if;
      end;

   end getinfo_oem;
end;
/
