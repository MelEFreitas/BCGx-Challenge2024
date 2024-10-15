import pandas as pd
import os
from dotenv import load_dotenv
from chatbot import Chatbot
from ragas.llms import LangchainLLMWrapper
from langchain_openai import ChatOpenAI
from ragas import evaluate
from datasets import Dataset  # Importar o Dataset da Hugging Face
from ragas.metrics import answer_relevancy,faithfulness,context_recall,context_precision,answer_correctness,answer_similarity

'''
Qual é o objetivo principal do Plano Nacional de Adaptação Mudança do Clima (PNA)? 
[22, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100]
Como o Plano Nacional de Enfrentamento à Emergência Climática trata a questão das secas no Brasil? 
'''



# Get api key
load_dotenv(".env")
OPENAI_API_KEY = os.environ.get('OPENAI_API_KEY')    

faiss_path = "faiss_index"

chatbot = Chatbot(  
        openai_api_key=OPENAI_API_KEY,   
        faiss_index_path = faiss_path
    )

# Função para aplicar o RAGAS nas respostas geradas
def apply_ragas(df):
    samples = []
    error_questions=[]
    print("Number of questions: ", len(df))
    
    for idx, row in df.iterrows():
        try:
            print(f"Processing question {idx+1}/{len(df)}")
            
            # Simulação da chamada do chatbot
            response, docs, chat_history = chatbot.run_chat_test(row['Pergunta'])
            
            # Criar uma amostra com a pergunta, contexto, resposta correta e resposta gerada
            sample = {
                'question': row['Pergunta'],  # Pergunta feita pelo usuário
                'contexts': [doc.page_content for doc in docs],  # Documento que contém a resposta
                'ground_truth': row['Resposta Esperada'],  # Resposta correta
                'answer': response  # Resposta do chatbot
            }
            
            # Adicionar a amostra à lista de samples
            samples.append(sample)
        
        except Exception as e:
            error_questions.append(idx+1)
            print(f"Error processing question {idx+1}/{len(df)}: {row['Pergunta']}")
            print(f"Error: {e}")
            continue
    
    print('Error questions:', error_questions)
    
    # Criar o dataset de avaliação com todas as amostras
    eval_dataset = pd.DataFrame(samples)
        
    return eval_dataset


def main(dataframe_path):
    
    print("\n----------------------------------------")
    print("Testing the ChatBot using RAGAS")
    print("----------------------------------------\n")
    
    qa_test = pd.read_csv(dataframe_path, encoding='ISO-8859-1')
    qa_test = qa_test[:100]
    
    # Aplicar RAGAS nas respostas geradas
    resultados_ragas = apply_ragas(qa_test)  
    
    # Converter o pandas DataFrame para o Dataset da Hugging Face
    eval_dataset = Dataset.from_pandas(resultados_ragas)  
    
    evaluator_llm = LangchainLLMWrapper(ChatOpenAI(model="gpt-4o")) 
    
    metrics = [
        faithfulness,
        answer_relevancy,
        context_recall,
        answer_correctness,
        answer_similarity
    ] 
    
    # Avaliar utilizando RAGAS
    results = evaluate(dataset=eval_dataset, metrics=metrics, llm=evaluator_llm)  
    
    df = results.to_pandas()  # Converter os resultados de volta para pandas
    
    print(df.head(10))   
    
    print("\nRAGAS for test dataset finished\n")  
    
    df.to_csv("results_ragas.csv", index=False)  # Salvar os resultados em um arquivo CSV      

if __name__ == "__main__":
    # Carregar seu dataset de perguntas, respostas, documentos e página
    dataset_path = "C:/Users/Melissa Freitas/Documents/Melissa/BCGx-Challenge2024/data/teste/qa_for_test.csv"
    main(dataset_path)