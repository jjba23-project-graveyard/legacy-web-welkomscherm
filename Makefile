# web-welkomscherm

# Copyright (C) 2024 Josep Jesus Bigorra Algaba

# web-welkomscherm is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# web-welkomscherm is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with web-welkomscherm. If not, see <https://www.gnu.org/licenses/>.

define do-build
	rm -rfv dist
	mkdir dist
	GUILE_AUTOCOMPILE=0 guile web-welkomscherm.scm
	cp -rfv resources/css dist/
	cp -rfv resources/js dist/
	cp -rfv resources/woff dist/
	@printf "\n\nall tasks completed\n\n"
endef

serve:
	darkhttpd ./dist --port 50024

render:
	$(call do-build)

dev:
	watchexec -i "dist/**" -r -e scm,css,js -- "make render && make serve"

fmt:
	find . -maxdepth 4 -name "*.scm" -type f -exec guix style -f {} \;

deploy: render
	rm -rf /srv/http/jointhefreeworld.org/joe-web-welkomscherm
	cp -rf dist /srv/http/jointhefreeworld.org/joe-web-welkomscherm
