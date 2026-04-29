{ config, pkgs, ... }:

{
	home.username = "hridesh";
	home.homeDirectory = "/home/hridesh";

	home.packages = with pkgs; [
		neofetch
	];

	home.stateVersion = "25.11";
}
