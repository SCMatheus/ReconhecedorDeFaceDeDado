%K = imagem de entrada
%h = altura da janela de interesse
%w = largura da janela de interesse

function [Z bi bj] = regiaoInteresse(K, h, w)
	[N, M, O] = size(K);
	if O == 3
        im = rgb2gray(K);
    else
        im = K;
    end
	%Limiarização
	p(2:N+1, 2:M+1) = im(:,:) >= 45;
	
	%Pré-processamento para calcular a soma dos elementos de qualquer submatriz em O(1)
	soma = zeros(N+1,M+1);
	for i = 2 : N+1
		for j = 2 : M+1
			soma(i,j) = int32(p(i,j))+soma(i,j-1)+soma(i-1,j)-soma(i-1,j-1);
		end
	end
		
	%Calcula as somas de todas as submatrizes de tamanho hxw 
	subSomas = soma(h+2:N+1, w+2:M+1) + soma(2:N+1-h, 2:M+1-w) - (soma(h+2:N+1, 2:M+1-w)+soma(2:N+1-h, w+2:M+1));
	
	maior = max(subSomas(:)); %Maior soma
	[i,j] = ind2sub(size(subSomas), find(subSomas==maior)); %Posições iniciais das submatrizes com a maior soma
	cntbest = size(i,1); %Quantidade de submatrizes com a maior soma
	
	%Posição inicial média das submatrizes com maior soma
	bi = ceil(sum(i)/cntbest);
	bj = ceil(sum(j)/cntbest);
	
	%Região de interesse
	Z(:,:,:) = K((bi:(bi+h)), (bj:(bj+w)),:);
	
end
