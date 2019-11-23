package SDL2::SDL;

sub attach {
	my( $ffi ) =  @_;

	# extern DECLSPEC int SDLCALL SDL_Init(Uint32 flags);
	# extern DECLSPEC int SDLCALL SDL_InitSubSystem(Uint32 flags);
	# extern DECLSPEC void SDLCALL SDL_QuitSubSystem(Uint32 flags);
	# extern DECLSPEC Uint32 SDLCALL SDL_WasInit(Uint32 flags);
	# extern DECLSPEC void SDLCALL SDL_Quit(void);
	$ffi->attach( SDL_Init          => [ 'uint32' ] => 'int'    );
	$ffi->attach( SDL_InitSubSystem => [ 'uint32' ] => 'int'    );
	$ffi->attach( SDL_QuitSubSystem => [ 'uint32' ] => 'void'   );
	$ffi->attach( SDL_WasInit       => [ 'uint32' ] => 'uint32' );
	$ffi->attach( SDL_Quit          => [ 'void'   ] => 'void'   );
}

1;
