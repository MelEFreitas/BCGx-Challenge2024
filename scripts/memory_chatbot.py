import argparse
import openai
import os
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings, ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from langchain.memory import ConversationSummaryMemory
from dotenv import load_dotenv

CHROMA_PATH = "chroma"

PROMPT_TEMPLATE = """
Answer the question based only on the following context:

{context}

---

Answer the question based on the above context: {question}
"""

# Load environment variables from the .env file
load_dotenv()

# Check if OPENAI_API_KEY is being loaded
api_key = os.getenv("OPENAI_API_KEY")
if not api_key:
    raise EnvironmentError("OPENAI_API_KEY not found in environment variables.")

def main():
    # Create CLI.
    parser = argparse.ArgumentParser()
    parser.add_argument("query_text", type=str, help="The query text.")
    args = parser.parse_args()
    query_text = args.query_text

    # Prepare the DB.
    embedding_function = OpenAIEmbeddings()
    db = Chroma(persist_directory=CHROMA_PATH, embedding_function=embedding_function)

    # Search the DB.
    results = db.similarity_search_with_relevance_scores(query_text, k=5)
    if len(results) == 0 or results[0][1] < 0.80:
        print(f"Unable to find matching results.")
        return

    context_text = "\n\n---\n\n".join([doc.page_content for doc, _score in results])

    # Initialize memory (ConversationSummaryMemory will keep track of context)
    memory = ConversationSummaryMemory(llm=ChatOpenAI(), max_token_limit=1000)  # Adjust the token limit as needed

    # Create prompt template.
    prompt_template = ChatPromptTemplate.from_template(PROMPT_TEMPLATE)
    prompt = prompt_template.format(context=context_text, question=query_text)

    # Initialize the model.
    model = ChatOpenAI()

    # Add the prompt to memory to persist the conversation context
    memory.add_message({"role": "system", "content": prompt})

    # Retrieve the memory
    memory_text = memory.retrieve()

    # Predict with memory context
    response_text = model.predict(memory_text)

    # Store the response in memory for future interactions
    memory.add_message({"role": "assistant", "content": response_text})

    # Print the response and sources
    sources = [doc.metadata.get("source", None) for doc, _score in results]
    formatted_response = f"Response: {response_text}\nSources: {sources}"
    print(formatted_response)

if __name__ == "__main__":
    main()
