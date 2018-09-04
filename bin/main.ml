open! Core
open Async
open Cohttp_async

let command =
  Command.async ~summary:"Start the shortlink server."
    Command.Let_syntax.(
      [%map_open
        let port = flag "port" (required int) ~doc:"PORT port to listen on"
        and shortlinks_fname =
          flag "file" (required string) ~doc:"FILE name of file with shortlinks"
        in
        fun () ->
          let open Deferred.Let_syntax in
          let%bind shortlinks =
            Reader.load_sexp_exn shortlinks_fname Shortlink.t_of_sexp
          in
          let%bind (_ : (Socket.Address.Inet.t, int) Server.t) =
            Shortlink.server ~port ~shortlinks
          in
          Deferred.never ()
      ])

let () = Command.run command
